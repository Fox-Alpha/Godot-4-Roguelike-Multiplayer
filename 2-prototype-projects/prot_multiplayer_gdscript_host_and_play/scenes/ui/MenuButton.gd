extends MenuButton

@onready var buttons := $/root/Main/CanvasLayerUI/ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GetPopup().IdPressed += ExitMenuPresses;
	get_popup().id_pressed.connect(OnExitMenuPresses)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func OnExitMenuPresses(id:int):
	#GD.Print($"Menu {GetPopup().GetItemText((int)id)} ({id}) is pressed");
	print("Menu %s (%s) is pressed" % [get_popup().get_item_text(id), str(id)])

	var isClient = get_tree().current_scene.get_node_or_null("ClientManager")
	var isServer = get_tree().current_scene.get_node_or_null("ServerManager")

	match id:
		0:
			if is_instance_valid(isServer):
				var peers = isServer.multiplayer.get_peers()
				for peer in peers:
					isServer.multiplayer.multiplayer_peer.disconnect_peer(peer)

				isServer.multiplayer.multiplayer_peer.close()
				isServer.queue_free()
			if is_instance_valid(isClient):
				isClient.multiplayer.multiplayer_peer.close()
				isClient.queue_free()

			buttons.show()
		1:
			get_tree().quit()
		_:
			pass
