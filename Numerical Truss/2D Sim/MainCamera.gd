extends Camera2D

var zoom_speed = Vector2(0.5, 0.5)

var actions = {"ui_up" : false, "ui_down" : false, "ui_left" : false, "ui_right" : false, "zoom_in" : false, "zoom_out" : false}

const moveSpeed = 500
const zoomRate = 0.5

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

func _process(delta):
	for key in actions.keys():
		actions[key] = Input.is_action_pressed(key)
	
	var dx = 0
	var dy = 0
	if actions["ui_up"]:
		dy -= moveSpeed*delta
	if actions["ui_down"]:
		dy += moveSpeed*delta
	if actions["ui_left"]:
		dx -= moveSpeed*delta
	if actions["ui_right"]:
		dx += moveSpeed*delta
	
	if actions["zoom_in"]:
		zoom *= pow(10.0, zoomRate*delta)
	if actions["zoom_out"]:
		zoom *= pow(10.0, -zoomRate*delta)
	
	offset.x += dx / zoom.x
	offset.y += dy / zoom.x
