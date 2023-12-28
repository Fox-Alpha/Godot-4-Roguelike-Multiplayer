extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = UiManager.get_scene("pause_menu")
# preload("res://scenes/ui/menu/pause_menu.tscn")


func _ready():
	$%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

## TODO: Umlagern in GameEvents
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
