extends PanelContainer

@onready var playernode: Node = $"../../Network/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		if %LobbyConnectedPlayers.visible:
			#Control/Lobby/MarginContainer/HBoxContainer/VBoxContainer2/ScrollContainer/LobbyConnectedPlayers
			display_players_connected(%LobbyConnectedPlayers)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		if %LobbyConnectedPlayers.visible:
			#Control/Lobby/MarginContainer/HBoxContainer/VBoxContainer2/ScrollContainer/LobbyConnectedPlayers
			display_players_connected(%LobbyConnectedPlayers)


# Function to display players connected,
# it refreshes each time it is called on Clients
func display_players_connected(node : Node):
	# Clear the previous list
	if multiplayer.is_server():
		return

	for c in node.get_children():
		c.queue_free()

	# Create the list of connected players
	# TODO	: peerliste aus MultioplayerAPI verwenden
	#		: Seperate Team Red and Team Blue
	var _peer_node_list : Array[Node] = AL_Globals.playernode.get_children()
#	_plist.append_array(playernode.get_children())
	var _plist = multiplayer.get_peers()

	for _p in _plist:
		var _peer : Node = AL_Globals.playernode.get_node_or_null("{0}".format([str(_p)]))

		if _peer == null: break

		var HBox := HBoxContainer.new()
		HBox.name = str(_peer.name)
		HBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		node.add_child(HBox)

		var lblplayer = Label.new()
		lblplayer.text = str(_peer.name)
		lblplayer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		HBox.add_child(lblplayer)


func _on_menu_button_pressed():
	# ToDo: Signal senden
#	quit_game()
	pass


func _on_spawn_team_red_button_pressed():
	AL_Network.add_client_player.rpc_id(1, multiplayer.get_unique_id(), "red")
#	var _err = AL_Network.add_player.rpc_id(1, multiplayer.get_unique_id(), "red")
#	if _err:
#		print(error_string(_err))
	hide()

func _on_spawn_team_blue_button_pressed():
	AL_Network.add_client_player.rpc_id(1, multiplayer.get_unique_id(), "red")
#	var _err = AL_Network.add_player.rpc_id(1, multiplayer.get_unique_id(), "blue")
#	var _err = rpc_id(1, "add_client_player", multiplayer.get_unique_id(), "blue")
#	if _err:
#		print(error_string(_err))
	hide()
