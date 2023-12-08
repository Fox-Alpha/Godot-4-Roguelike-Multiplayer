extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta):
	#TODO: Set entityArray path depend on NetworkMode
	#if $"/root/Main/ServerAuthority/EntityArray".get_child_count() > 0:
		#self.text = ""
		#var entities = get_node("/root/Main/ServerAuthority/EntityArray").get_children()

		#TODO: Set 2D position of entity
		#for entity in entities:
			#self.text += entity.name + " " + str(entity.position.snapped(Vector3.ONE*0.1)) + "\n"
	pass
