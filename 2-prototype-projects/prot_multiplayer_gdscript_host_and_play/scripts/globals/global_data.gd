extends Node

enum NetworkMode {
	NETWORKERROR = -1,		# Error durring creation
	NOTSTARTED = 0,			# Main Menu
	SINGLEPLAYERMODE,		# Local Singleplayer Mode
	CLIENTONLYMODE,			# Client Only
	SERVERONLYMODE,			# Dedicated Server
	SERVERCLIENTMODE,		# Host and Play Mode
}

enum NetworkModeError {
	NOTSTARTED = 0,		# Main Menu
	CANTCREATECLIENT = ERR_CANT_CREATE,
	CANTCREATESERVER = ERR_CANT_CREATE,
	CANTCONNECT = ERR_CANT_CONNECT
}

const NETWORKPORT : int = 21277
const NETWORKSERVERMAXPEERS : int = 4

@onready var GlobalNetworkMode : NetworkMode = NetworkMode.NOTSTARTED

##UI
var UIDebugLabel :Node


func _ready() -> void:
	UIDebugLabel = get_tree().current_scene.get_node("CanvasLayerUI/Debug/Label")
	GlobalSignals.networkmodechanged.connect(OnNetworkModeChange)


func OnNetworkModeChange(mode : NetworkMode) -> void:
	print("Signal > GlobalData: NetworkModeChanges %s" % str(mode))
	GlobalNetworkMode = mode
