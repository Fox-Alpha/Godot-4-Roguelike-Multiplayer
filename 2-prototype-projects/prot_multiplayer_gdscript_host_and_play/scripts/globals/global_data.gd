extends Node

enum NetworkMode {
	CLIENTONLYMODE,			# Client Only
	SERVERONLYMODE,			# Dedicated Server
	SINGLEPLAYERMODE,	# Local Singleplayer Mode
	SERVERCLIENTMODE,	# Dedicated Server Mode
	NOTSTARTED = -1
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
