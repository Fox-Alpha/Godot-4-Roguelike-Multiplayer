extends Node2D

const MAINTITLE = "MAINTITLE"

var _server_scene = preload("res://scenes/server/server.tscn")
var _client_scene = preload("res://scenes/client/client.tscn")

#@onready var startbuttons: Control = %Buttons
@onready var buttons := $CanvasLayerUI/ButtonGroup

func _ready() -> void:
	GlobalSignals.MainTitleChanged.emit(MAINTITLE)


func _on_menu_button_pressed(extra_arg_0: int) -> void:
	var title : String = "";

	match extra_arg_0:
		0:
			$CanvasLayerUI/Control/Label.text = "Standalone Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SINGLEPLAYERMODE)

			add_child(_server_scene.instantiate())
			await get_tree().create_timer(0.1).timeout
			add_child(_client_scene.instantiate())

			title = "Single Player"
		1:
			$CanvasLayerUI/Control/Label.text = "Client Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.CLIENTONLYMODE)
			add_child(_client_scene.instantiate())
			title = "Client"
		2:
			$CanvasLayerUI/Control/Label.text = "Server Side"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERONLYMODE)
			add_child(_server_scene.instantiate())
			title = "Dedicated Server"
		3:
			$CanvasLayerUI/Control/Label.text = "Server & Play"
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERCLIENTMODE)
			add_child(_server_scene.instantiate())
			await get_tree().create_timer(0.1).timeout
			add_child(_client_scene.instantiate())
			title = "Host and Play Mode"
		_:
			GodotLogger.error("MainMenuButton::_on_menu_button_pressed (%s) -> This should never happen !" % [extra_arg_0])

	#TODO: Own Scene for readding
	buttons.hide()
	GlobalSignals.MainTitleChanged.emit(title)


func _on_button_quit_app_pressed():
	#TODO: check for active network
	get_tree().quit()


func _on_button_group_visibility_changed() -> void:
	if visible:
		#DisplayServer.window_set_title(MAINTITLE)
		GlobalSignals.MainTitleChanged.emit(MAINTITLE)
	pass # Replace with function body.
