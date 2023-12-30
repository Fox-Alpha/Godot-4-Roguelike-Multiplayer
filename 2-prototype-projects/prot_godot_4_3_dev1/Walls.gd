extends Node

enum WallDirection{
	NORTH,
	EAST,
	WEST,
	SOUTH
}

@export_category("Walls Setup")
@export var walls : Array[PackedScene]

@onready var vpsize : Vector2i = get_tree().current_scene.get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	printt("ViewPort Size: ", vpsize)
	createwall(WallDirection.NORTH)
	createwall(WallDirection.EAST)
	createwall(WallDirection.SOUTH)
	createwall(WallDirection.WEST)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func createwall(dir : WallDirection):
	var wall : StaticBody2D = walls[dir].instantiate()
	var wallsize : Vector2i = Vector2i.ZERO
	var wallpos : Vector2i = Vector2i.ZERO
	var wallrotation : int = 0
	var wallname : String = WallDirection.keys()[dir]
	
	match dir:
		WallDirection.NORTH:
			if wall.has_method("SetWallPosition"):
				wallsize = Vector2i(vpsize.x, 16)
				wallpos = Vector2i(0,0)
				wallrotation = 0
				wall.call_deferred("SetWallPosition", wallname, wallsize, wallpos, wallrotation)
		WallDirection.EAST:
			if wall.has_method("SetWallPosition"):
				wallsize = Vector2i(vpsize.y, 16)
				wallpos = Vector2i(vpsize.x,0)
				wallrotation = 90
				wall.call_deferred("SetWallPosition", wallname, wallsize, wallpos, wallrotation)
		WallDirection.SOUTH:
			if wall.has_method("SetWallPosition"):
				wallsize = Vector2i(vpsize.x, 16)
				wallpos = vpsize
				wallrotation = 180
				wall.call_deferred("SetWallPosition", wallname, wallsize, wallpos, wallrotation)
		WallDirection.WEST:
			if wall.has_method("SetWallPosition"):
				wallsize = Vector2i(vpsize.y, 16)
				wallpos = Vector2i(0,vpsize.y)
				wallrotation = -90
				wall.call_deferred("SetWallPosition", wallname, wallsize, wallpos, wallrotation)

	add_child(wall)
	pass
