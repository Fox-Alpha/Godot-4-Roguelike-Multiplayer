class_name Player extends CharacterBody2D

const SPEED := 500.0

const ACCELERATION: float = 15.0

var direction := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, SPEED * direction.x, ACCELERATION)
		velocity.y = move_toward(velocity.y, SPEED * direction.y, ACCELERATION)
	#elif multiplayer.is_server():
		move_and_slide()
