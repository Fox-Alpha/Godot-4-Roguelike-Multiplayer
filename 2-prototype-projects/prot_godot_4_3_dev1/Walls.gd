extends Node

enum WallDirection{
	NORTH,
	EAST,
	WEST,
	SOUTH
}

@export_category("Walls Setup")
@export var walls : Array[PackedScene]

@onready var vpsize : Vector2 = get_tree().current_scene.get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	printt("VP Size: ", vpsize)
	setwall(WallDirection.NORTH)
	setwall(WallDirection.EAST)
	setwall(WallDirection.SOUTH)
	setwall(WallDirection.WEST)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func setwall(dir : WallDirection):
	var w : StaticBody2D = walls[dir].instantiate()
	w.name = WallDirection.keys()[dir]
	match dir:
		WallDirection.NORTH:
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
			w.rotation_degrees = 180
			w.find_child("Texture").size.x = vpsize.x
			w.global_position = vpsize
		WallDirection.WEST:
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
