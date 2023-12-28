extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = $%PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = $%CountLabel


var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(meta_upgrade: MetaUpgrade):
	self.upgrade = meta_upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	upgrade.next_experience_cost = calculate_next_xp_cost(current_quantity)

	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.next_experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "Max"

	progress_label.text = str(currency) + "/" + str(upgrade.next_experience_cost)
	count_label.text = "x%d" % current_quantity


func select_card():
	$AnimationPlayer.play("selected")


func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.next_experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")


func calculate_next_xp_cost(quantity:int) -> int:
	#upgrade.experience_cost *
#	(upgrade.xp_multiplicator +
#	upgrade.increase_xp_multiplicator *
#	current_quantity)
	var nx : int = upgrade.experience_cost
	if quantity > 0:
		for i in range(1, quantity+1):
			nx += nx * (upgrade.xp_multiplicator + upgrade.increase_xp_multiplicator)
	else:
		nx = upgrade.experience_cost

	return nx
