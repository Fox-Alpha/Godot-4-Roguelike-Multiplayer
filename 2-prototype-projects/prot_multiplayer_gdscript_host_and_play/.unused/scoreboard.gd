extends PanelContainer


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


# Function to display players connected,
# it refreshes each time it is called on Clients
func display_players_connected(node : Node, team : String):
	# Clear the previous list
	if multiplayer.is_server():
		return

	if not is_instance_valid(node):
		return

	for c in node.get_children():
		c.queue_free()

	# Create the list of connected players
	# TODO	: peerliste aus MultioplayerAPI verwenden
	#		: Seperate Team Red and Team Blue
	var _peer_node_list : Array[Node] = AL_Globals.playernode.get_children()
#	print("perrlist: {0}, {1}".format([_peer_node_list[0].name, _peer_node_list[1].name]))
#	_plist.append_array(playernode.get_children())
	var _plist = multiplayer.get_peers()

	for _p in _peer_node_list:
		var _peer : Node = AL_Globals.playernode.get_node_or_null("{0}".format([_p]))

		if _peer == null:
#			print("peer node konnte nicht ermittelt werden")
			break

#		print("Getting peers count: {0}".format([_plist.size()]))

		if not _peer.teamname == team:
			print("Getting peer name, color, team: {0} / {1} / {2}".format([_peer.name, _peer.teamname, team]))
			continue

		var HBox := HBoxContainer.new()
		HBox.name = str(_peer.name)
		HBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		node.add_child(HBox)
#		print("Adding peer to list: {0}".format([_peer.name]))

		var lblplayer = Label.new()
		lblplayer.text = str(_peer.name)
		lblplayer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		HBox.add_child(lblplayer)


func _on_player_kick_pressed(butt):
#	var metavar : PackedStringArray = butt.get_meta_list()

#	for m in metavar:
	var m : int = butt.get_meta("p_id")
#	print_debug("Player Kicked ", m)
	multiplayer.multiplayer_peer.disconnect_peer(m)
#	pass


# Function to display players connected, it refreshes each time it is called on Server
func _on_server_display_players_connected(team : String) -> void:
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		if  multiplayer.is_server():
			if multiplayer.has_multiplayer_peer():
				var peerlist = multiplayer.get_peers()

				for p in peerlist:
					# peer bereits in liste
					if %PlayersConnectedListTeamBlue.get_node_or_null(str(p)) != null: #.find_child(str(p)):
						continue

					if %PlayersConnectedListTeamRed.get_node_or_null(str(p)) != null: #.find_child(str(p)):
						continue

					var HBox := HBoxContainer.new()
					HBox.name = str(p)
					HBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					# node.add_child(HBox)

					var lblplayer = Label.new()
					lblplayer.text = str(p)
					lblplayer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					HBox.add_child(lblplayer)

					var button = Button.new()
					button.text = "KICK"
					button.name = str(p)
					button.set_meta("p_id", p)
					button.pressed.connect(_on_player_kick_pressed.bind(button))
					HBox.add_child(button)

					match team:
					# BLUE Team
						"blue":
							%PlayersConnectedListTeamBlue.add_child(HBox)
					# RED Team
						"red":
							%PlayersConnectedListTeamRed.add_child(HBox)


func _on_visibility_changed() -> void:
	pass # Replace with function body.
