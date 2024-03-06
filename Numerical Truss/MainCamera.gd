extends Camera2D

var zoom_speed = Vector2(0.5, 0.5)

func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_camera(zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_camera(-zoom_speed)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom

func zoom_camera(zoom_direction):
	var previous_mouse_position = get_local_mouse_position()
	zoom += zoom_direction

	var diff = previous_mouse_position - get_local_mouse_position()
	offset += diff
