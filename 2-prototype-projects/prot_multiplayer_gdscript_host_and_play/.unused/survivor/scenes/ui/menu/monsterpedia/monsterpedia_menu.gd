extends CanvasLayer

# ToSo: Change references to Monsters
@export var upgrades: Array[MetaUpgrade] = []
@export var monsters: Array[MonsterPedia] = []

@onready var grid_container = $%GridContainer
@onready var back_button = $%BackButton

# ToDo: Change name
var monsterpedia_card_scene = UiManager.get_scene("monsterpedia_card_scene")


func _ready():
	back_button.pressed.connect(on_back_pressed)
	if monsters.size() > 0:
		for child in grid_container.get_children():
			child.queue_free()

		for monster in monsters:
			var monsterpedia_card_instance = monsterpedia_card_scene.instantiate()
			grid_container.add_child(monsterpedia_card_instance)
			monsterpedia_card_instance.set_meta_upgrade(monster)


func on_back_pressed():
#	ScreenTransition.transition()
	ScreenTransition.transition_to_packedscene(UiManager.get_scene("main_menu"))
	await ScreenTransition.transitioned_halfway

