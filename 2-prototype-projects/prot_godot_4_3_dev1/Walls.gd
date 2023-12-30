extends Node

enum WallDirection{
	NORTH,
	EAST,
	WEST,
	SOUTH
}

var wallsettings : Dictionary = {
	"NORTH": {
		"wallname": "WALL_NORTH",
		"wallsize": Vector2i(0, 16),
		"wallposition": Vector2i(0, 0),
		"wallrotation": 0
	},
	"EAST": {
		"wallname": "WALL_EAST",
		"wallsize": Vector2i(0, 16),
		"wallposition": Vector2i(vpsize.x, 0),
		"wallrotation": 90
	},
	"SOUTH": {
		"wallname": "WALL_SOUTH",
		"wallsize": Vector2i(0, 16),
		"wallposition": Vector2i(vpsize.x, 0),
		"wallrotation": 180
	},
	"WEST": {
		"wallname": "WALL_WEST",
		"wallsize": Vector2i(0, 16),
		"wallposition": vpsize,
		"wallrotation": -90
	},
}

var map : TileMap

@export_category("Walls Setup")
@export var walls : Array[PackedScene]

@onready var vpsize : Vector2i = get_tree().current_scene.get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().current_scene.get_node_or_null("TileMap")
	var mapRect : Rect2i = map.get_used_rect()
	var mapSize : Vector2i = mapRect.size * 64
	printt("ViewPort Size: ", vpsize)
	printt("TileMap Size: ", mapSize)
	print("Screen Center: (%s / %s)" % [vpsize.x / 2.0, vpsize.y / 2.0])
	
	
	#TODO: Fix Position and Size to Map
	wallsettings["NORTH"]["wallposition"] = mapRect.position
	wallsettings["EAST"]["wallposition"] = Vector2i(mapRect.end.x, 0)
	wallsettings["SOUTH"]["wallposition"] = mapRect.end
	wallsettings["WEST"]["wallposition"] = Vector2i(mapRect.position.x,mapRect.end.y)

	wallsettings["NORTH"]["wallsize"] = Vector2i(mapRect.size.x, 16)
	wallsettings["EAST"]["wallsize"] = Vector2i(mapRect.size.y, 16)
	wallsettings["SOUTH"]["wallsize"] = Vector2i(mapRect.size.x, 16)
	wallsettings["WEST"]["wallsize"] = Vector2i(mapRect.size.y, 16)
	
	#wallsettings["NORTH"]["wallposition"] = Vector2i(0, 0)
	#wallsettings["EAST"]["wallposition"] = Vector2i(vpsize.x, 0)
	#wallsettings["SOUTH"]["wallposition"] = vpsize
	#wallsettings["WEST"]["wallposition"] = Vector2i(0,vpsize.y)
#
	#wallsettings["NORTH"]["wallsize"] = Vector2i(vpsize.x, 16)
	#wallsettings["EAST"]["wallsize"] = Vector2i(vpsize.y, 16)
	#wallsettings["SOUTH"]["wallsize"] = Vector2i(vpsize.x, 16)
	#wallsettings["WEST"]["wallsize"] = Vector2i(vpsize.y, 16)
	
	#print(wallsettings)
	#
	#createwall(WallDirection.NORTH)
	#createwall(WallDirection.EAST)
	#createwall(WallDirection.SOUTH)
	#createwall(WallDirection.WEST)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func createwall(dir : WallDirection):
	var wall : StaticBody2D = walls[dir].instantiate()
	var wallname : String = WallDirection.keys()[dir]
	
	match dir:
		WallDirection.NORTH:
				var _x = wall.call_deferred("SetWallPositionDict",wallsettings[wallname]) if wall.has_method("SetWallPositionDict") else false
		WallDirection.EAST:
				var _x = wall.call_deferred("SetWallPositionDict",wallsettings[wallname]) if wall.has_method("SetWallPositionDict") else false
		WallDirection.SOUTH:
				var _x = wall.call_deferred("SetWallPositionDict",wallsettings[wallname]) if wall.has_method("SetWallPositionDict") else false
		WallDirection.WEST:
				var _x = wall.call_deferred("SetWallPositionDict",wallsettings[wallname]) if wall.has_method("SetWallPositionDict") else false

	add_child(wall)
	pass
