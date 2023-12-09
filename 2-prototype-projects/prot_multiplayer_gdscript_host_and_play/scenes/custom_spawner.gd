extends MultiplayerSpawner

const PLAYER = preload("res://objects/entities/player/player.tscn")
const DUMMY = preload("res://objects/entities/dummy/dummy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = _OnCustomSpawn
	set_multiplayer_authority(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _OnCustomSpawn(data) -> Node:
	var _spawnedPlayerID:int = data
	var _localID : int = multiplayer.get_unique_id()

	## DEBUG
	print(	""">> MultiplayerSpawner::CustomSpawnFunction():
			Local UniqueId: ({%d}
			Authority: {%d})""" % [multiplayer.get_unique_id(), get_multiplayer_authority()]);

	#push_warning(">> MultiplayerSpawner::CustomSpawnFunction():
			#\tLocal UniqueId: ({%d}
			#\tAuthority: {%d})" % [multiplayer.get_unique_id(), get_multiplayer_authority()]);

	var dummy : Node2D = DUMMY.instantiate()
	dummy.name = str(data)
	var pos = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	dummy.global_position = pos
	if _localID == 1:
		dummy.hide()

	dummy.set_multiplayer_authority(data)

	return dummy


