extends Node

enum WallDirection{
	NORTH,
	EAST,
	WEST,
	SOUTH
}

@export_category("Walls Setup")
@export var walls : Array[PackedScene]
@export var wallscene : PackedScene = preload("res://wall.tscn")

#@export var wall_north : StaticBody2D
#@export var wall_east : StaticBody2D
#@export var wall_south : StaticBody2D
#@export var wall_west : StaticBody2D

@onready var vpsize : Vector2 = get_tree().current_scene.get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	printt("VP Size: ", vpsize)
	#for dir in WallDirection.keys():
		#setwall(WallDirection[dir])
	setwall(WallDirection.NORTH)
	setwall(WallDirection.EAST)
	setwall(WallDirection.SOUTH)
	setwall(WallDirection.WEST)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setwall(dir : WallDirection):
	var w : StaticBody2D = walls[dir].instantiate()
	w.name = WallDirection.keys()[dir]
	match dir:
		WallDirection.NORTH:
			#w.find_child("Texture").size = Vector2i(vpsize.x, 16)
			w.find_child("Texture").size.x = vpsize.x
			w.global_position.x = 0
			w.global_position.y = 0
			w.global_rotation = 0
		WallDirection.EAST:
			w.find_child("Texture").size.x = vpsize.y
			w.global_position.x = vpsize.x
			w.global_position.y = 0
			w.rotation_degrees = 90
		WallDirection.SOUTH:
			#w.global_rotation = 180
			w.rotation_degrees = 180
			w.find_child("Texture").size.x = vpsize.x
			w.global_position = vpsize
			#w.global_position.y = vpsize.y-40
		WallDirection.WEST:
			#w.global_rotation = -90
			#w.rotate(deg2rad(-90))
			w.rotation_degrees = -90
			w.rotate
			w.find_child("Texture").size.x = vpsize.y
			w.global_position.x = 0
			w.global_position.y = vpsize.y

	printt("Wall %s GlobalPosition: %s" % [w.name, w.global_position])
	printt("Wall %s Width: %s" % [w.name, w.find_child("Sprite2D").texture.width])
	printt("Wall %s Height: %s" % [w.name, w.find_child("Sprite2D").texture.height])

	add_child(w)
	pass
