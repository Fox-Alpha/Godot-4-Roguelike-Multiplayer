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

# MAINLOG.info("%sNetworkModeChanges %s" % [_MSGPREFIX, str(mode)])
const _MSGPREFIX = "Signal > GlobalData: "

var MAINLOG : Log

var _GlobalNetworkMode :  NetworkMode :
	set(value):
		_GlobalNetworkMode = value
	get:
		return _GlobalNetworkMode


##UI
var UIDebugLabel :Node


func _ready() -> void:
	GodotLogger._prefix = "GLOBAL"
	MAINLOG = GodotLogger.with("GlobalLogger")

	_GlobalNetworkMode = NetworkMode.NOTSTARTED
	UIDebugLabel = get_tree().current_scene.get_node("CanvasLayerUI/Debug/Label")
	GlobalSignals.networkmodechanged.connect(OnNetworkModeChange)


func OnNetworkModeChange(mode : NetworkMode) -> void:
	MAINLOG.info("%sNetworkModeChanges %s" % [_MSGPREFIX, str(mode)])
	_GlobalNetworkMode = mode


func GetGlobalNetworkMode() -> NetworkMode:
	return _GlobalNetworkMode
