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

## UI Label Signals
signal DebugLabelText(msg:String, color:Color)


func _ready() -> void:
	servercreated.connect(OnServerCreated)
	clientcreated.connect(OnClientCreated)
	clientconnected.connect(OnClientConnected)
	networkmodechanged.connect(OnNetworkModeChanged)

	DebugLabelText.connect(OnDebugLabelText)


func OnServerCreated() -> void:
	print("Signal: Server Created")
	pass


func OnClientCreated() -> void:
	print("Signal: Client Created")
	pass


func OnClientConnected() -> void:
	pass


func OnNetworkModeChanged(mode : GlobalData.NetworkMode) -> void:
	print("Signal > GlobalSignals: NetworkModeChanges %s" % str(mode))


func OnDebugLabelText(msg: String, color:Color = Color.WHITE):
	GlobalData.UIDebugLabel.text = msg

	if not color == Color.WHITE:
		GlobalData.UIDebugLabel.modulate = color
