extends Node

## Network Signals
# If a Server has created
signal servercreated
# if a Client has created
signal clientcreated
# if client is connected to server
signal clientconnected
# the global network Mode
signal networkmodechanged


func _ready() -> void:
	servercreated.connect(OnServerCreated)
	clientcreated.connect(OnClientCreated)
	clientconnected.connect(OnClientConnected)
	networkmodechanged.connect(OnNetworkModeChanged)


func OnServerCreated() -> void:
	pass


func OnClientCreated() -> void:
	pass


func OnClientConnected() -> void:
	pass


func OnNetworkModeChanged() -> void:
	pass
