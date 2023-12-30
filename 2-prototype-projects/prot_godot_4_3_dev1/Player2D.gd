extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	#var st : SceneTree = get_tree()
	#var cs : Node = st.current_scene
	#var vp : Viewport = get_viewport()
	#var cam : Camera2D = vp.get_camera_2d()
	#var scp : Vector2 = cam.get_screen_center_position()
	global_position = get_tree().current_scene.get_viewport().get_camera_2d().get_screen_center_position()
	pass


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
