extends Node2D

const LightTexture = preload("res://maps/map01/scripts/light.png")
const GRID_SIZE = 32

@onready var fog := %Fog

var display_width = ProjectSettings.get("display/window/size/window_width_override")
var display_height = ProjectSettings.get("display/window/size/window_height_override")

var fogImage := Image.new()
var fogTexture := ImageTexture.new()
var lightImage = LightTexture.get_image()
var light_offset := Vector2(LightTexture.get_width()/2.0, LightTexture.get_height()/2.0)

func _ready():
	var fog_image_width = display_width/GRID_SIZE
	var fog_image_height = display_height/GRID_SIZE
	fogImage = Image.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.BLACK)
	lightImage.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE
	
	var ppos = %Map01.to_local(%Player2D.global_position)
	update_fog(ppos/GRID_SIZE)

func update_fog(new_grid_position):
	#fogImage.lock()
	#lightImage.lock()
	
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, new_grid_position - light_offset)
	
	#fogImage.unlock()
	#lightImage.unlock()
	update_fog_image_texture()

func update_fog_image_texture():
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

func _input(event):
	#var ppos = %TileMap.to_local(%Player2D.global_position)
	#update_fog(ppos/GRID_SIZE)
	pass
