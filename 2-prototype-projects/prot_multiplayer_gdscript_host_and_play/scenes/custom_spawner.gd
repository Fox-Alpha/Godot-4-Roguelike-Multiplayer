extends MultiplayerSpawner

const PLAYER = preload("res://objects/entities/player/player.tscn")
const DUMMY = preload("res://objects/entities/dummy/dummy.tscn")

var _logger : Log


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = _OnCustomSpawn
	set_multiplayer_authority(1)


func _enter_tree() -> void:
	_logger = get_parent().get_logger() as Log
	_logger.info("Getting Logger: %s" % _logger.name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _OnCustomSpawn(data) -> Node:
	var _spawnedPlayerID:int = data
	var _localID : int = multiplayer.get_unique_id()

	## DEBUG
	_logger.info(""">> MultiplayerSpawner::CustomSpawnFunction():
			Local UniqueId: ({%d}
			Authority: {%d})""" % [multiplayer.get_unique_id(), get_multiplayer_authority()]);

	var dummy : Node2D = DUMMY.instantiate()
	dummy.name = str(data)
	var pos = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	dummy.global_position = pos
	if _localID == 1:
		dummy.hide()

	dummy.set_multiplayer_authority(data)

	return dummy
