extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.is_server():
		$ColorRect.color = Color("006e6f")
	else:
		$ColorRect.color = Color.DARK_KHAKI #("645f5a")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
