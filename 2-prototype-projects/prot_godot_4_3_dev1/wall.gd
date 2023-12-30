extends StaticBody2D

@onready var vpsize : Vector2i = get_tree().current_scene.get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func SetWallPositionDict(data: Dictionary):
	name = data["wallname"]
	get_node_or_null("Texture").size = data["wallsize"]
	global_position = data["wallposition"]
	rotation_degrees = data["wallrotation"]
	printt("Wall %s GlobalPosition: %s / Size: %s / Rotation: %s" % [name, global_position, find_child("Texture").size, rotation_degrees])
	return true
