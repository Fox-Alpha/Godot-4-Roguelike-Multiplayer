class_name Server_Manager extends Node

@export var _port : int = 9999

@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
@onready var entity_array: Node2D = $EntityArray

var entityArray : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !_CreateLocalServer():
		printerr("Error durring Server creation !")
	else:
		print("Server Ready for connection !")
		GlobalSignals.servercreated.emit()
		push_warning("This Session starts the server")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _CreateLocalServer() -> bool:

	_multiplayer.peer_connected.connect(OnPeerConnected)
	_multiplayer.peer_disconnected.connect(OnPeerDisconnected)

	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new();
	var numplayer = GlobalData.NETWORKSERVERMAXPEERS if GlobalData.GlobalNetworkMode != GlobalData.NetworkMode.SINGLEPLAYERMODE else 1

	var error = peer.create_server(
		GlobalData.NETWORKPORT, numplayer)


	if error != OK:
		print("Error during Server creation %d " % error_string(error))
		GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.NOTSTARTED)
		return false

	_multiplayer.multiplayer_peer = peer
	var path = get_path()
	get_tree().set_multiplayer(_multiplayer, path)
	print("Server listening on ", _port)

	return error == OK


func OnPeerConnected(id : int) -> void :
	print("Peer ", id, " connected")
	var _spawner : Node = get_node_or_null("PlayerSpawner").spawn(id)

func OnPeerDisconnected(id : int) -> void :
	print("Peer ", id, " disconnected")

	var client := get_node_or_null("./EntityArray/%s" % str(id))
	if is_instance_valid(client):
		var peers =  multiplayer.get_peers()
		if id in peers:
			multiplayer.multiplayer_peer.disconnect_peer(id)
		print(client.name)
		client.queue_free()
	pass

