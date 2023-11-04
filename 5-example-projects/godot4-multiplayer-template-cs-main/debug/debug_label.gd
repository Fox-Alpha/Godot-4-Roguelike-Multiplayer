extends Label

func _process(_delta):
	self.text = ""
	if $"/root/Main/ServerAuthority/EntityArray".get_child_count() > 0:
		var entities = get_node("/root/Main/ServerAuthority/EntityArray").get_children()

		for entity in entities:
			self.text += entity.name + " " + str(entity.position.snapped(Vector3.ONE*0.1)) + "\n"
