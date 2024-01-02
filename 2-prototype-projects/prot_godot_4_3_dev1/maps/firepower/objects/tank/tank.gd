extends CharacterBody2D

@export var camera_2d : Camera2D

const SPEED = 300.0
var movecam : bool = false


func _ready() -> void:
	movecam = is_instance_valid(camera_2d)


func _process(delta: float) -> void:
	camera_2d.global_position = global_position


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * SPEED # * delta
		velocity.y = direction.y * SPEED # * delta
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	#if move_and_slide():
		#for index in get_slide_collision_count():
			#var collision := get_slide_collision(index)
			#prints(collision.get_collider())
		#prints("CollCount: %s " % get_slide_collision_count())
		#prints("CollCount: %s " % get_last_slide_collision().get_collider().name)
	#move_and_collide(velocity)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire_bullet"):
		# Instantiate Bullet
		pass
