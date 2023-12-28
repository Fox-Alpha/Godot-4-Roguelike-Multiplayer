extends CanvasLayer

var options_scene = preload("res://scenes/ui/menu/options_menu.tscn")

## TODO: getter for scenes from UI Manager

func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%UpgradesButton.pressed.connect(on_upgrades_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	%MonsterPediaButton.pressed.connect(on_monsterpedia_pressed)


func on_play_pressed():
#	ScreenTransition.transition()
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")
	await ScreenTransition.transitioned_halfway
#	var _error = get_tree().change_scene_to_file("res://scenes/main/main.tscn")
#	print("ChangeScene: Main -> " + str(_error))


func on_upgrades_pressed():
#	ScreenTransition.transition()
	ScreenTransition.transition_to_scene("res://scenes/ui/menu/meta_upgrade/meta_menu.tscn")
	await ScreenTransition.transitioned_halfway
#	var _error = get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")
#	print("ChangeScene: Meta -> " + str(_error))


func on_options_pressed():
	ScreenTransition.transition()
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_pressed():
	get_tree().quit()


func on_options_closed(options_instance: Node):
	options_instance.queue_free()


func on_monsterpedia_pressed() -> void:
#	ScreenTransition.transition()
#	var mp_instance = monsterpedia_scene.instantiate()
#	add_child(mp_instance)
#	mp_instance.back_pressed.connect(on_monsterpedia_closed.bind(mp_instance))

	ScreenTransition.transition_to_scene("res://scenes/ui/menu/monsterpedia/monsterpedia_menu.tscn")
	await ScreenTransition.transitioned_halfway
	pass
