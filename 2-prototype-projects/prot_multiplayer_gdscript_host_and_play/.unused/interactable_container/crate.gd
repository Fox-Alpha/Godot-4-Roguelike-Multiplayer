extends ItemContainer

@onready var label = $Label

var mouseover : bool = false

func hit():
	if not opened:
		$LidSprite.hide()
		$AudioStreamPlayer2D.play()
		for i in range(5):
			var pos = $SpawnPositions.get_child(randi()%$SpawnPositions.get_child_count()).global_position
			open.emit(pos, current_direction)
		opened = true
		label.visible = false
		mouseover = false


func _on_mouse_entered():
	if not opened:
		label.visible = true
		mouseover = true


func _on_mouse_exited():
	if not opened:
		label.visible = false
		mouseover = false
		
func _unhandled_input(event : InputEvent):
	
#	print(event.as_text())dddds
	
	if mouseover:
		if event.is_action_pressed("interact"):
			hit()

func _on_input_event(_viewport, _event, _shape_idx):
	pass # Replace with function body.
