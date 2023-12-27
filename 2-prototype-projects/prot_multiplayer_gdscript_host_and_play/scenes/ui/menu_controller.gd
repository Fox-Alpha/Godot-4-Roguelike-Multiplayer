extends Control

@onready var MAINTITLE = ProjectSettings.get_setting("application/config/name")

var _server_scene = preload("res://scenes/server/server.tscn")
var _client_scene = preload("res://scenes/client/client.tscn")

#@onready var startbuttons: Control = %Buttons
#@onready var buttons := preload("res://scenes/ui/button_group.tscn") #$CanvasLayerUI/ButtonGroup


func _ready() -> void:
	GlobalSignals.MainTitleChanged.emit(MAINTITLE)


func _on_menu_button_pressed(extra_arg_0: int) -> void:
	match extra_arg_0:
		0:
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SINGLEPLAYERMODE)

			get_tree().current_scene.add_child(_server_scene.instantiate())
			await get_tree().create_timer(0.1).timeout
			get_tree().current_scene.add_child(_client_scene.instantiate())

		1:
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.CLIENTONLYMODE)
			get_tree().current_scene.add_child(_client_scene.instantiate())

		2:
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERONLYMODE)
			get_tree().current_scene.add_child(_server_scene.instantiate())

		3:
			GlobalSignals.networkmodechanged.emit(GlobalData.NetworkMode.SERVERCLIENTMODE)
			get_tree().current_scene.add_child(_server_scene.instantiate())
			await get_tree().create_timer(0.1).timeout
			get_tree().current_scene.add_child(_client_scene.instantiate())

		_:
			GodotLogger.error("MainMenuButton::_on_menu_button_pressed (%s) -> This should never happen !" % [extra_arg_0])

	#TODO: Own Scene for readding
	self.hide()


func _on_button_quit_app_pressed():
	#TODO: check for active network
	get_tree().quit()


func _on_button_group_visibility_changed() -> void:
	if visible:
		GlobalSignals.MainTitleChanged.emit(MAINTITLE)

	var igm := get_tree().current_scene.get_node_or_null("CanvasLayerUI/IngameMenu")
	igm.visible = !visible
