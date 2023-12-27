class_name Server_Manager extends Node

@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
@onready var entity_array: Node2D = $EntityArray

var ServerLogger : Log

var entityArray : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !_CreateLocalServer():
		ServerLogger.error("Error durring Server creation !")
	else:
		ServerLogger.info("Server Ready for connection !")
		GlobalSignals.servercreated.emit()


func _enter_tree() -> void:
	ServerLogger = GodotLogger.with("Server")
	ServerLogger.name ="ServerLogger"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _CreateLocalServer() -> bool:
	_multiplayer.peer_connected.connect(OnPeerConnected)
	_multiplayer.peer_disconnected.connect(OnPeerDisconnected)

	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new();
	var numplayer = GlobalData.NETWORKSERVERMAXPEERS if GlobalData.GetGlobalNetworkMode() != GlobalData.NetworkMode.SINGLEPLAYERMODE else 1

	var error = peer.create_server(
		GlobalData.NETWORKPORT, numplayer)


	if error != OK:
		ServerLogger.error("Error during Server creation %s " % error_string(error))
		GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.NETWORKERROR)
		return false

	_multiplayer.multiplayer_peer = peer
	var path = get_path()
	get_tree().set_multiplayer(_multiplayer, path)
	ServerLogger.info("Server listening on ", GlobalData.NETWORKPORT)

	return error == OK


func OnPeerConnected(id : int) -> void :
	ServerLogger.info("Peer %s connected" % id)
	var _spawner : Node = get_node_or_null("PlayerSpawner").spawn(id)

func OnPeerDisconnected(id : int) -> void :
	ServerLogger.info("Peer %s disconnected" % id)

	var client := get_node_or_null("./EntityArray/%s" % str(id))
	if is_instance_valid(client):
		var peers =  multiplayer.get_peers()
		if id in peers:
			multiplayer.multiplayer_peer.disconnect_peer(id)

		print(client.name)
		client.queue_free()
	pass


func get_logger() -> Log:
	return ServerLogger
