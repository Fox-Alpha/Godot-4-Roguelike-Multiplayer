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
	GlobalData.MAINLOG.info("MenuButton %s (%s) is pressed" % [get_popup().get_item_text(id), str(id)])

	var isClient = get_tree().current_scene.get_node_or_null("ClientManager")
	var isServer = get_tree().current_scene.get_node_or_null("ServerManager")

	match id:
		0:
			if is_instance_valid(isServer):
				var peers = isServer.multiplayer.get_peers()
				print("Back to Menu", peers)
				for peer in peers:
					var cliententitys : Node2D = isServer.entity_array
					if is_instance_valid(cliententitys):
						for node in cliententitys.get_children():
							node.queue_free()
							await node.tree_exited
					isServer.multiplayer.multiplayer_peer.disconnect_peer(peer)
#
				isServer.multiplayer.multiplayer_peer.close()
				isServer.queue_free()

			if is_instance_valid(isClient):
				#isClient.multiplayer.multiplayer_peer.close()
				#isClient.multiplayer.disconnect_peer(multiplayer.multiplayer_peer.TARGET_PEER_SERVER)
				isClient.queue_free()
				await isClient.NOTIFICATION_EXIT_TREE

			buttons.show()
		1:
			get_tree().quit()
		_:
			pass
