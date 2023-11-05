extends Node3D

var _server_scene = preload("res://scenes/Server.tscn")
var _client_scene = preload("res://scenes/Client.tscn")

@onready var startbuttons: Control = %Buttons



func _on_button_pressed(host:int):
		var title : String = "";
		if host == 1: # Host with Player
			$Control/Label.text = "Server + Client Side"
			var svr_scn_inst = _server_scene.instantiate()
			self.add_child(svr_scn_inst)
			#await svr_scn_inst.ready
			await get_tree().create_timer(0.5).timeout
			## Start Client after Server initialition
			self.add_child(_client_scene.instantiate())
			title = "Host & Play"
		elif host == 2: # Dedicated server host
			$Control/Label.text = "Dedicated Server Side"
			self.add_child(_server_scene.instantiate())
			title = "Dedicated Server"
		else: # Client
			$Control/Label.text = "Client only Side"
			self.add_child(_client_scene.instantiate())
			title = "Client"

		DisplayServer.window_set_title(title)
		$ServerAuthority/MultiplayerSpawner.startmode = host
		startbuttons.queue_free()
