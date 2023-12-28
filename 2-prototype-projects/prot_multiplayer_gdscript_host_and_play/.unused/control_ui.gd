extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Menu.show()
	%ChatBox.position.y = get_viewport().size.y - (get_viewport().size.y / 3) - 15
	%ChatBox.hide()
	%SendMessage.position.y = get_viewport().size.y - (get_viewport().size.y / 6)
	%SendMessage.hide()
	%Scoreboard.hide()
	%Lobby.hide()
	%QuitConfirmation.hide()

	AL_Signalbus.host_server_created.connect(_on_host_server_created)
	AL_Signalbus.local_client_created.connect(_on_local_client_created)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(_event: InputEvent) -> void:
	if %Menu.visible: return # If the starting menu is not visible it means we are in the game
#	return
#	@warning_ignore("unreachable_code")
	if not multiplayer.is_server():
		# Hold the Tab key to display connected players and press Enter to send a message
		if Input.is_key_pressed(KEY_TAB):
#			%Scoreboard.display_players_connected_proxy()
			%Scoreboard.show()
		elif Input.is_action_just_released("ui_focus_next"):
			%Scoreboard.hide()
#TODO: check doubling
		if Input.is_action_just_pressed("ui_focus_next"):
			%Scoreboard.display_players_connected(%Scoreboard.get_node_or_null("MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/PlayersConnectedListTeamRed"), "red")
			%Scoreboard.display_players_connected(%Scoreboard.get_node_or_null("MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/PlayersConnectedListTeamBlue"), "blue")
			%Scoreboard.show()
		elif Input.is_action_just_released("ui_focus_next"):
			%Scoreboard.hide()


func _on_host_server_created() -> void:
	%Menu.hide()
#	%Scoreboard.show()
	pass


func _on_local_client_created() -> void:
	%Menu.hide()
	%Lobby.show()
	pass
