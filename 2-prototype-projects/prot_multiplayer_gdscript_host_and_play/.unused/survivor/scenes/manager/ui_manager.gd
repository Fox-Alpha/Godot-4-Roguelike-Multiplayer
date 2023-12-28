extends Node
class_name UIManager

@onready var _game_scenes : = {
	"main_menu": preload("res://scenes/ui/menu/main_menu.tscn"),
	"options_menu": preload("res://scenes/ui/menu/options_menu.tscn"),
	"end_screen": preload("res://scenes/ui/ingame/end_screen.tscn"),
	"ability_update_screen": preload("res://scenes/ui/shared/ability_upgrade_card.tscn"),
	"meta_menu": preload("res://scenes/ui/menu/meta_upgrade/meta_menu.tscn"),
	"meta_upgrade_card_scene" : preload("res://scenes/ui/menu/meta_upgrade/meta_upgrade_card.tscn"),
	"monsterpedia_menu": preload("res://scenes/ui/menu/monsterpedia/monsterpedia_menu.tscn"),
	"monsterpedia_card_scene" : preload("res://scenes/ui/menu/monsterpedia/monsterpedia_card.tscn"),
	"pause_menu": preload("res://scenes/ui/menu/pause_menu.tscn"),
	"upgrade_screen": preload("res://scenes/ui/ingame/upgrade_screen.tscn")
}


func get_scene(scene_name) -> PackedScene:
	if _game_scenes.has(scene_name):
		return _game_scenes[scene_name]

	return null
