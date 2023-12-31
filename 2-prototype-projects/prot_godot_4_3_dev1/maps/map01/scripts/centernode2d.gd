extends Node

@export var NodesToCenter : Array[Node]
@onready var screencenter = get_tree().current_scene.get_viewport().get_visible_rect().get_center()


# Called when the node enters the scene tree for the first time.
func _ready():
	var ChildsToCenter = get_children()
	
	for c in ChildsToCenter:
		(c as Node2D) .global_position = screencenter
		print("Node %s Position: %s" % [c.name, c.global_position])

	for c in NodesToCenter:
		(c as Node2D) .global_position = screencenter
		print("Node %s Position: %s" % [c.name, c.global_position])
