extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var screencenter = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	print("Screen Center: %s" % screencenter)
	global_position = screencenter
	print("Player Position: %s" % global_position)
