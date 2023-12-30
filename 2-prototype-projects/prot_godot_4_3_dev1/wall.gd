extends StaticBody2D

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func SetWallPosition(dir: String, wallsize: Vector2i, wallpos: Vector2i, wallrotation: int):
	name = "WALL_%s" % dir
	get_node_or_null("Texture").size = wallsize
	global_position = wallpos
	rotation_degrees = wallrotation
	
	printt("Wall %s GlobalPosition: %s" % [name, global_position])
	printt("Wall %s Size: %s" % [name, find_child("Texture").size])
	printt("Wall %s Rotation: %s" % [name, rotation_degrees])
	pass
