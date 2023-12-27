extends Node

## Network Signals
# If a Server has created
signal servercreated
# if a Client has created
signal clientcreated
# if client is connected to server
signal clientconnected
# the global network Mode
signal networkmodechanged(mode)

## UI Signals
signal DebugLabelText(msg:String, color:Color)
signal MainTitleChanged(title:String)

# MAINLOG.info("%sNetworkModeChanges %s" % [_MSGPREFIX, str(mode)])
const _MSGPREFIX = "Signal > GlobalSignals: "

func _ready() -> void:
	servercreated.connect(OnServerCreated)
	clientcreated.connect(OnClientCreated)
	clientconnected.connect(OnClientConnected)
	networkmodechanged.connect(OnNetworkModeChanged)
	MainTitleChanged.connect(OnMainTitleChanged)

	DebugLabelText.connect(OnDebugLabelText)


func OnMainTitleChanged(newTitle:String) -> void:
	DisplayServer.window_set_title(newTitle)


func OnServerCreated() -> void:
	GlobalData.MAINLOG.info("%sServer Created" % [_MSGPREFIX])
	pass


func OnClientCreated() -> void:
	GlobalData.MAINLOG.info("%sClient Created" % [_MSGPREFIX])
	pass


func OnClientConnected() -> void:
	pass


func OnNetworkModeChanged(mode : GlobalData.NetworkMode) -> void:
	GlobalData.MAINLOG.info("%sNetworkModeChanges %s" % [_MSGPREFIX, str(mode)])


func OnDebugLabelText(msg: String, color:Color = Color.WHITE):
	GlobalData.UIDebugLabel.text = msg

	if not color == Color.WHITE:
		GlobalData.UIDebugLabel.modulate = color
