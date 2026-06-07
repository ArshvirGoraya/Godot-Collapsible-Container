extends Node

enum MouseImageType {NORMAL, HOVER, CLICK}
@export var mouse_images : Dictionary[MouseImageType, Texture2D]
const MOUSE_CURSOR_HOTSPOT : Vector2 = Vector2(0, 10)
const CURSOR_SIZE_PIXELS : int = 45
const CURSOR_SIZE_PIXELS_CLICK : int = 50

func _ready() -> void:
	_filter_cursor_images()

func _filter_cursor_images() -> void:
	for mouse_image_type in mouse_images.keys():
		var mouse_texture : Texture2D = mouse_images.get(mouse_image_type)
		var mouse_image :Image = mouse_texture.get_image()
		if mouse_image_type == MouseImageType.CLICK:
			mouse_image.resize(CURSOR_SIZE_PIXELS_CLICK, CURSOR_SIZE_PIXELS_CLICK, Image.INTERPOLATE_NEAREST)
		else:
			mouse_image.resize(CURSOR_SIZE_PIXELS, CURSOR_SIZE_PIXELS, Image.INTERPOLATE_NEAREST)
		var filtered_mouse_texture : ImageTexture = ImageTexture.create_from_image(mouse_image)
		mouse_images.set(mouse_image_type, filtered_mouse_texture)
	_set_normal_cursor_images()

func _set_normal_cursor_images() -> void:
	Input.set_custom_mouse_cursor(mouse_images.get(MouseImageType.NORMAL), Input.CursorShape.CURSOR_ARROW, MOUSE_CURSOR_HOTSPOT)
	Input.set_custom_mouse_cursor(mouse_images.get(MouseImageType.HOVER), Input.CursorShape.CURSOR_POINTING_HAND, MOUSE_CURSOR_HOTSPOT)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			Input.set_custom_mouse_cursor(mouse_images.get(MouseImageType.CLICK), Input.CursorShape.CURSOR_ARROW, MOUSE_CURSOR_HOTSPOT)
			Input.set_custom_mouse_cursor(mouse_images.get(MouseImageType.CLICK), Input.CursorShape.CURSOR_POINTING_HAND, MOUSE_CURSOR_HOTSPOT)
		else:
			_set_normal_cursor_images()
