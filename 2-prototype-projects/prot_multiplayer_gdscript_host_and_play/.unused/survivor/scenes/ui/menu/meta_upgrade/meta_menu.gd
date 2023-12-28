extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer
@onready var back_button = $%BackButton

var meta_upgrade_card_scene = UiManager.get_scene("meta_upgrade_card_scene")
# preload("res://scenes/ui/menu/meta_upgrade_card.tscn")


func _ready():
	back_button.pressed.connect(on_back_pressed)
	if upgrades.size() > 0:
		for child in grid_container.get_children():
			child.queue_free()

		for upgrade in upgrades:
			var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
			grid_container.add_child(meta_upgrade_card_instance)
			meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_pressed():
#	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/ui/menu/main_menu.tscn")
