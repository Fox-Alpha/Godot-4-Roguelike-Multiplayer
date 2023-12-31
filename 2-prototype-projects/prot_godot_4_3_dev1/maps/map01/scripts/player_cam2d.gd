extends Camera2D

var map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().current_scene.get_node_or_null("Map01")
	var mapRect : Rect2i = map.get_used_rect()
	var tileSize = 64
	var worldSizeInPixels : Vector2i = mapRect.size * tileSize
	print(worldSizeInPixels)
	#limit_top = worldSizeInPixels.x
	#limit_bottom = worldSizeInPixels.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
