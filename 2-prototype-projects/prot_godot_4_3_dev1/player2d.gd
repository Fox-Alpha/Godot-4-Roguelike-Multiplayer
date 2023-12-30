extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var FoW = $"../FogOfWar"


#func _ready():
	#pass


func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * SPEED # * delta
		velocity.y = direction.y * SPEED # * delta
		var ppos = %TileMap.to_local(%Player2D.global_position)
		FoW.update_fog(ppos/32)
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
