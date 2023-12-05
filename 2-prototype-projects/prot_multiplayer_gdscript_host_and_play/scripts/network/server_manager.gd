class_name Server_Manager extends Node

@export var _port : int = 9999

@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
var entityArray : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !_CreateLocalServer():
		printerr("Error durring Server creation !")
	else:
		print("Server Ready for connection !")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _CreateLocalServer() -> bool:

	_multiplayer.peer_connected.connect(OnPeerConnected)
	_multiplayer.peer_disconnected.connect(OnPeerDisconnected)

	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new();
	var error = peer.create_server(_port);

	_multiplayer.multiplayer_peer = peer

	get_tree().set_multiplayer(_multiplayer)
	print("Server listening on ", _port)


	return error == OK


func OnPeerConnected(id : int) -> void :
	print("Peer ", id, " connected")
	pass


func OnPeerDisconnected(id : int) -> void :
	print("Peer ", id, " disconnected")
	pass

