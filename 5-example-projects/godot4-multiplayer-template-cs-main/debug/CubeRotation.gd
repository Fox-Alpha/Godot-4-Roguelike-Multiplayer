extends MeshInstance3D

#func _process(_delta):
	#if multiplayer.is_server():
		#self.rotate_y(delta * 4)
	#else:
		#self.rotate_y(-delta * 4)
	#pass
