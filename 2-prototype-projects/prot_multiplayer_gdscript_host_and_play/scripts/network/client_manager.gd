class_name Client_Manager extends Node

#[Export] private string _address = "localhost";
@export var _adress : String = "localhost"
#[Export] private int _port = 9999;
@export var _port : int = 21277

#private SceneMultiplayer _multiplayer = new();
@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
#private Node _entityArray;
#var _entityArray : Node


#[Export] private int _lerpBufferWindow = 50;
#[Export] private int _maxLerp = 150;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if _Connect():
		printerr("Error durring Server creation !")
	else:
		print("Client Ready !")
		GlobalSignals.clientcreated.emit()
		push_warning("This Session starts a Client")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _Connect() -> bool:
		#_multiplayer.ConnectedToServer += OnConnectedToServer;
		#_multiplayer.PeerPacket += OnPacketReceived;
		#_multiplayer.ServerDisconnected += OnServerDisconnected;
		#_multiplayer.ConnectionFailed += OnConnectionFailed;
		#_multiplayer.PeerConnected += OnPeerConnected;
		#_multiplayer.PeerDisconnected += OnPeerDisconnected;

	_multiplayer.connected_to_server.connect(OnConnectedToServer)
	_multiplayer.connection_failed.connect(OnConnectionFailed)
	_multiplayer.server_disconnected.connect(OnServerDisconnect)
	#_multiplayer.server_disconnected.connect(OnPeerConnected)
	#_multiplayer.server_disconnected.connect(OnPeerDisconnected)

	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	var error = peer.create_client(_adress, GlobalData.NETWORKPORT)
	if error != OK:
		print("Error during Server creation %d " % error_string(error))
		GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.NOTSTARTED)
	else:
		_multiplayer.multiplayer_peer = peer;

		var path = get_path()
		get_tree().set_multiplayer(_multiplayer, path)

	return error != OK

func OnConnectedToServer() -> void:
	print("Client connected to Server:", _adress, ":", _port)
	DisplayServer.window_set_title(str("Connected to: ", _adress, ":", _port, " / as: ", multiplayer.get_unique_id()))
	#GetNode<Label>("Debug/Label").Text += $"\n{Multiplayer.GetUniqueId()}";
	pass


func OnServerDisconnect() -> void:
	_multiplayer = null;
	print("Server disconnected:", _adress, ":", _port)

	#GetNode<Label>("Debug/Label").Modulate = Colors.Red;
	#GetNode<Label>("Debug/Label").Text = $"\nServer has closed the Connection !\nQuitting in 5 Seconds";
	#await ToSignal(GetTree().CreateTimer(5), "timeout");
	#GetTree().Quit();
	GlobalSignals.DebugLabelText.emit("\nServer has closed the Connection !\nQuitting in 5 Seconds", Color.RED)
	pass


func OnConnectionFailed() -> void:
	push_error("ClientManager::OnConnectionFailed(): Connecting to: {0}:{1} has failed".format([_adress,_port]))
	print("ClientManager::OnConnectionFailed(): Connecting to: {0}:{1} has failed".format([_adress,_port]))
	pass
