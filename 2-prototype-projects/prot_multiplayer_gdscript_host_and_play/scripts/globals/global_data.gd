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
var UICtrllabel : Node


func _ready() -> void:
	GodotLogger._prefix = "GLOBAL"
	MAINLOG = GodotLogger.with("GlobalLogger")

	UIDebugLabel = get_tree().current_scene.get_node_or_null("CanvasLayerUI/Debug/Label")
	UICtrllabel =  get_tree().current_scene.get_node_or_null("CanvasLayerUI/Control/Label")

	_GlobalNetworkMode = NetworkMode.NOTSTARTED
	GlobalSignals.networkmodechanged.connect(OnNetworkModeChange)


func OnNetworkModeChange(mode : NetworkMode) -> void:
	MAINLOG.info("%sNetworkModeChanges %s" % [_MSGPREFIX, str(mode)])
	_GlobalNetworkMode = mode
	var title : String = ""

	match GetGlobalNetworkMode() as NetworkMode:
		NetworkMode.NOTSTARTED:			# Main Menu
			print("")
		NetworkMode.SINGLEPLAYERMODE:		# Local Singleplayer Mode
			GlobalData.UICtrllabel.text = "Standalone Side"
			title = "Single Player"
			print("")
		NetworkMode.CLIENTONLYMODE:			# Client Only
			GlobalData.UICtrllabel.text = "Client Side"
			title = "Client"
			print("")
		NetworkMode.SERVERONLYMODE:			# Dedicated Server
			GlobalData.UICtrllabel.text = "Server Side"
			title = "Dedicated Server"
			print("")
		NetworkMode.SERVERCLIENTMODE:		# Host and Play Mode
			GlobalData.UICtrllabel.text = "Host & Play"
			title = "Host and Play Mode"
			print("")
		_:
			print("")

	GlobalSignals.MainTitleChanged.emit(title)



func GetGlobalNetworkMode() -> NetworkMode:
	return _GlobalNetworkMode
