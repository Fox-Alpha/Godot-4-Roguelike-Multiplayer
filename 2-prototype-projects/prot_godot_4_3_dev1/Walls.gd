extends Node

enum WallDirection{
	NORTH,
	EAST,
	WEST,
	SOUTH
}

@export_category("Walls Setup")
#@export var walls : Array = [StaticBody2D]
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setwall(dir : WallDirection):
	var w := wallscene.instantiate()
	w.name = WallDirection.keys()[dir]
	match dir:
		WallDirection.NORTH:
			w.find_child("Sprite2D").texture.width = vpsize.x
			w.find_child("Sprite2D").texture.height = 16
			w.global_position.y = 0
			w.global_position.x = vpsize.x / 2
		WallDirection.SOUTH:
			w.find_child("Sprite2D").texture.width = vpsize.x
			w.find_child("Sprite2D").texture.height = 16
			w.global_position.y = vpsize.y
			w.global_position.x = vpsize.x / 2
		WallDirection.WEST:
			w.find_child("Sprite2D").texture.width = 16
			w.find_child("Sprite2D").texture.height = vpsize.y
			w.global_position.y = vpsize.y / 2
			w.global_position.x = 0
		WallDirection.EAST:
			w.find_child("Sprite2D").texture.width = 16
			w.find_child("Sprite2D").texture.height = vpsize.y
			w.global_position.y = vpsize.y / 2
			w.global_position.x = vpsize.x

	printt("Wall %s Width: %s" % [w.name, w.find_child("Sprite2D").texture.width])
	printt("Wall %s Height: %s" % [w.name, w.find_child("Sprite2D").texture.height])
	printt("Wall %s GlobalPosition: %s" % [w.name, w.global_position])
	
	
	add_child(w)
	pass
