extends Node

enum NetworkMode {
	CLIENTMODE,			# Client Only
	SERVERMODE,			# Dedicated Server
	SINGLEPLAYERMODE,	# Local Singleplayer Mode
	SERVERCLIENTMODE,	# Dedicated Server Mode
	NOTSTARTED = -1
}

@onready var GlobalNetworkMode : NetworkMode = NetworkMode.NOTSTARTED
