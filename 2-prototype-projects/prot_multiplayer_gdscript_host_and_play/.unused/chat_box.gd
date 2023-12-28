extends PanelContainer


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_button_pin_box_toggled(button_pressed):
	%ChatBoxDisapearsTimer.paused = button_pressed

	if $ChatBoxDisapearsTimer.paused:
		$Control/ChatBox/MarginContainer/VBoxContainer/HBoxContainer/ButtonPinBox.text = "Pinned"
	else:
		$Control/ChatBox/MarginContainer/VBoxContainer/HBoxContainer/ButtonPinBox.text = "unPinned"


func _on_chat_box_disapears_timer_timeout():
	hide()
