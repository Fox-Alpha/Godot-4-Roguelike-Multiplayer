class_name Client_Manager extends Node

#[Export] private string _address = "localhost";
@export var _adress : String = "localhost"

#private SceneMultiplayer _multiplayer = new();
@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
@onready var buttons := $/root/Main/CanvasLayerUI/ButtonGroup

var ClientLogger : Log


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _Connect():
		ClientLogger.error("Error durring Server creation !")
	else:
		ClientLogger.info("Client Ready !")
		GlobalSignals.clientcreated.emit()


func _enter_tree() -> void:
	ClientLogger = GodotLogger.with("ClientLogger")
	ClientLogger.name = "ClientLogger"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _Connect() -> bool:
	#_multiplayer.PeerPacket += OnPacketReceived;

	_multiplayer.connected_to_server.connect(OnConnectedToServer)
	_multiplayer.connection_failed.connect(OnConnectionFailed)
	_multiplayer.server_disconnected.connect(OnServerDisconnect)
	#_multiplayer.server_disconnected.connect(OnPeerConnected)
	_multiplayer.peer_disconnected.connect(OnPeerDisconnected)

	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	var error = peer.create_client(_adress, GlobalData.NETWORKPORT)
	if error != OK:
		ClientLogger.error("Error during Server creation %d " % error_string(error))

		GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.NETWORKERROR)
	else:
		_multiplayer.multiplayer_peer = peer;

		var path = get_path()
		get_tree().set_multiplayer(_multiplayer, path)

	return error != OK

func OnConnectedToServer() -> void:
	ClientLogger.info("Client connected to Server:%s:%s" % [_adress, GlobalData.NETWORKPORT])
	GlobalSignals.MainTitleChanged.emit("Connected to: ", _adress, ":", GlobalData.NETWORKPORT, " / as: ", multiplayer.get_unique_id())


func OnServerDisconnect() -> void:
	_multiplayer = null;
	ClientLogger.info("Server disconnected: %s:%s" % [_adress, GlobalData.NETWORKPORT])

	GlobalSignals.DebugLabelText.emit("\nServer has closed the Connection !\nQuitting in 5 Seconds", Color.RED)
	await get_tree().create_timer(5).timeout
	GlobalSignals.DebugLabelText.emit("")
	var isClient = self

	if is_instance_valid(isClient):
		isClient.multiplayer.multiplayer_peer.close()
		isClient.queue_free()

	buttons.show()


func OnConnectionFailed() -> void:
	ClientLogger.error("ClientManager::OnConnectionFailed(): Connecting to: {0}:{1} has failed".format([_adress, GlobalData.NETWORKPORT]))


func OnPeerDisconnected(id):
	ClientLogger.info("Client: Client %d disconnected" % id)
	ClientLogger.info("Connected Peers:\n%s" % multiplayer.get_peers())


func get_logger() -> Log:
	return ClientLogger
