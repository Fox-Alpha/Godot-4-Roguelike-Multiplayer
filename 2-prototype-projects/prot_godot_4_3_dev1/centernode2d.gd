extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = get_tree().current_scene.get_viewport().get_visible_rect().get_center()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
