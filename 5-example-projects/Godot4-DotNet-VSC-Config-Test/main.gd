extends Node2D

var deltatime : float = 0.0

func _ready() -> void:
	DisplayServer.window_set_title("VSC Test Configuration ... runing")

func _process(delta: float) -> void:
	if deltatime >= 1:
		print(deltatime)
		deltatime = 0.0

	deltatime += delta
