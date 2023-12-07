extends MultiplayerSpawner

const PLAYER = preload("res://objects/entities/player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_multiplayer_authority(1)
	#var customSpawnFunction : Callable = _OnCustomSpawn
	spawn_function = _OnCustomSpawn

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _OnCustomSpawn(data:int) -> Node:
	var spawnedPlayerID:int = data
	var localID : int = multiplayer.get_unique_id()

	## DEBUG
	#print("OnCustomSpawn() : ", multiplayer.get_unique_id(), " : ", data)
	print(	""">> MultiplayerSpawner::CustomSpawnFunction():
			Local UniqueId: ({%d}
			Authority: {%d})""" % [multiplayer.get_unique_id(), get_multiplayer_authority()]);


	if localID == 1:					# is local Server
		print("Local Server")
		var server : Node = Node.new()
		server.name = str(data)

		server.set_multiplayer_authority(1)
		return server
	elif localID == spawnedPlayerID:	# is local Player
		print("local player")
		pass
	else:								# all other peers
		print("other peer")
		pass

	var player : CharacterBody2D = PLAYER.instantiate()
	player.name = str(data)
	#player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	var pos = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	player.global_position = pos

	player.set_multiplayer_authority(data)

	return player
