extends Node2D

#var _server_scene = preload("res://scenes/Server.tscn")
#var _client_scene = preload("res://scenes/Client.tscn")

@onready var startbuttons: Control = %Buttons
#@onready var buttons := $ButtonsGroup

func _on_menu_button_pressed(extra_arg_0: int) -> void:
	var title : String = "";

	match extra_arg_0:
		0:
			$CanvasLayerUI/Control/Label.text = "Standalone Side"
			#self.add_child(_client_scene.instantiate())
			title = "Single Player"
		1:
			$CanvasLayerUI/Control/Label.text = "Client Side"
			#self.add_child(_client_scene.instantiate())
			title = "Client"
		2:
			$CanvasLayerUI/Control/Label.text = "Server Side"
			#self.add_child(_server_scene.instantiate())
			title = "Dedicated Server"
		_:
			print("This should never happen !")

	##Todo: Own Scene for readding
	#startbuttons.queue_free()
	DisplayServer.window_set_title(title)


