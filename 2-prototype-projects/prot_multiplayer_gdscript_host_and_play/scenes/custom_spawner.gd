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


func _OnCustomSpawn(data) -> Node:
	print("OnCustomSpawn() : ", multiplayer.get_unique_id(), " : ", data)
	var player : CharacterBody2D = PLAYER.instantiate()
	player.name = str(data)
	player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	var pos = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	player.global_position = pos
	player.set_multiplayer_authority(data)
	return player
