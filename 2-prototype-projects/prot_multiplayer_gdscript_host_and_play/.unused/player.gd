extends CharacterBody2D

@export var teamcolor : Color
@export var teamname : String
var multiplayerauthority : int = -1
var player_is_server: bool = false


func _ready():
	if get_multiplayer_authority() == multiplayerauthority:
		player_is_server = multiplayer.is_server()
		%Authority.visible = true
	pass


func _physics_process(_delta):
#	if get_multiplayer_authority() != multiplayerauthority: return
	# ToDo: Check for Authority for Host Character ID 1
#	if not multiplayer.is_server():
#		if not is_multiplayer_authority(): return
#		var vel = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 500
#		if vel != Vector2.ZERO:
#			velocity = vel
#			move_and_slide()

	# Only for Host Character
#	elif get_multiplayer_authority() == multiplayerauthority:
	if is_multiplayer_authority():
		var vel = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 500
		if vel != Vector2.ZERO:
			velocity = vel
			move_and_slide()


func _on_tree_entered():
	$ReferenceRect/TeamColor.color = teamcolor
	set_multiplayer_authority(str(name).to_int())
	multiplayerauthority = str(name).to_int()

