extends CharacterBody2D

const SPEED := 500.0

@export var acceleration: float = 15.0

var direction := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity.x = move_toward(velocity.x, SPEED * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, SPEED * direction.y, acceleration)

	move_and_slide()
