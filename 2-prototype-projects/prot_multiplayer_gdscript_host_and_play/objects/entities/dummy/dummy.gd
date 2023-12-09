extends CharacterBody2D

const SPEED := 500.0
const ACCELERATION: float = 15.0
@export var direction := Vector2.ZERO

var player_name: Label

func _ready() -> void:
	player_name = $PlayerName
	player_name.text = name

func _unhandled_key_input(_event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return

	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func _process(_delta: float) -> void:
	#if !multiplayer.is_server():
	if is_multiplayer_authority():
		velocity.x = move_toward(velocity.x, SPEED * direction.x, ACCELERATION)
		velocity.y = move_toward(velocity.y, SPEED * direction.y, ACCELERATION)
	#if multiplayer.is_server():
		move_and_slide()


func _enter_tree() -> void:
	if multiplayer.get_unique_id() == multiplayer.multiplayer_peer.TARGET_PEER_SERVER:
		get_node("Icon").self_modulate = Color.LAWN_GREEN
	else:
		get_node("Icon").self_modulate = randomize_modulation()




func randomize_modulation() -> Color:
	var color : Color = Color(
		randf_range(0.0, 1.0),
		randf_range(0.0, 1.0),
		randf_range(0.0, 1.0),
		1
	)
	return color
