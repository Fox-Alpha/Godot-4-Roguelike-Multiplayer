extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready():
	set_multiplayer_authority(1)
	#var customSpawnFunction : Callable = _OnCustomSpawn
	spawn_function = _OnCustomSpawn

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _OnCustomSpawn(data) -> Node:
	print("OnCustomSpawn() : ", multiplayer.get_unique_id(), " : ", data)
	var TestNode : Node = Node.new()
	TestNode.name = "ClientNode_" + str(data)
	return TestNode
