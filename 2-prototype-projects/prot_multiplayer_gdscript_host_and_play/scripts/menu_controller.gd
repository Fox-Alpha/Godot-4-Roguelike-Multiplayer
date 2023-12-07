extends Node2D

var _server_scene = preload("res://scenes/server/server.tscn")
var _client_scene = preload("res://scenes/client/client.tscn")

#@onready var startbuttons: Control = %Buttons
@onready var buttons := $CanvasLayerUI/ButtonGroup

func _on_menu_button_pressed(extra_arg_0: int) -> void:
	var title : String = "";

	match extra_arg_0:
		0:
			$CanvasLayerUI/Control/Label.text = "Standalone Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SINGLEPLAYERMODE)
			self.add_child(_server_scene.instantiate())
			self.add_child(_client_scene.instantiate())
			title = "Single Player"
		1:
			$CanvasLayerUI/Control/Label.text = "Client Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.CLIENTONLYMODE)
			self.add_child(_client_scene.instantiate())
			title = "Client"
		2:
			$CanvasLayerUI/Control/Label.text = "Server Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERONLYMODE)
			self.add_child(_server_scene.instantiate())
			title = "Dedicated Server"
		3:
			$CanvasLayerUI/Control/Label.text = "Server & Play"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERCLIENTMODE)
			self.add_child(_server_scene.instantiate())
			self.add_child(_client_scene.instantiate())
			title = "Host and Play Mode"
		_:
			print("This should never happen !")

	##Todo: Own Scene for readding
	buttons.hide()
	DisplayServer.window_set_title(title)


func _on_button_quit_app_pressed():
	get_tree().quit()
