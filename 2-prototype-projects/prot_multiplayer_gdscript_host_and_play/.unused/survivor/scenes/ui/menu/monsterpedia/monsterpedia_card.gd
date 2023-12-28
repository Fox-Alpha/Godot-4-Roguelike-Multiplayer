extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var enemy_texture_rect = %EnemyTextureRect
@onready var progress_bar_hitpoints = %ProgressBarHitpoints
@onready var progress_bar_speed = %ProgressBarSpeed
@onready var progress_bar_acceloration = %ProgressBarAcceloration
@onready var count_label = $%CountLabel
@onready var progress_bar = $%ProgressBar

#@export_subgroup("MonsterPediaInfo")
#@export var experience_cost: int = 10
#@export var is_unlocked : bool
#@export var time_played_to_unlock : int
#@export var enemy_texture : Texture2D
#@export var title: String
#@export_multiline var description: String
#
#
#@export_subgroup("EnemyProperties")
#@export var EnemyName: String = "BasicEnemy"
#@export var weigthness: float = 10.0
#@export var max_health: float = 10.0
#@export_range(0, 1) var drop_percent: float = .5
#@export var max_speed: int = 40
#@export var acceleration: float = 5.0

## Obsolete
@onready var progress_label = %ProgressLabel


# ToSo: Change references to Monsters
var upgrade: MetaUpgrade
var monster: MonsterPedia


#func _ready():
#	pass


func set_meta_upgrade(_monster: MonsterPedia):
	self.monster = _monster
	name_label.text = monster.title
	description_label.text = monster.description
	enemy_texture_rect.texture = monster.enemy_texture
	progress_bar_hitpoints.value = monster.max_health
	progress_bar_speed.value = monster.max_speed
	progress_bar_acceloration.value = monster.acceleration
	count_label.text = str(monster.time_played_to_unlock)
#	progress_bar = monster.time_played_to_unlock

#	update_progress()


# ToDo: Save unlocked monsters
func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]

	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_quantity


func select_card():
	$AnimationPlayer.play("selected")
