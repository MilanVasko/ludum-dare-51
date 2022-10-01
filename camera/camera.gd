extends Camera2D

var dragging := false
var last_mouse_position: Vector2
var current_mouse_position: Vector2
var min_zoom := Vector2(1, 1)
var max_zoom := Vector2(10, 10)

func _process(_delta):
	if dragging:
		position -= (current_mouse_position - last_mouse_position) * zoom
		last_mouse_position = current_mouse_position

func _unhandled_input(event):
	if event is InputEventMouse:
		if event is InputEventMouseButton:
			dragging = event.pressed
			var delta := Vector2()
			if event.button_index == BUTTON_WHEEL_UP:
				delta = -Vector2.ONE
			elif event.button_index == BUTTON_WHEEL_DOWN:
				delta = Vector2.ONE
			zoom = Vector2(clamp(zoom.x + delta.x, min_zoom.x, max_zoom.x), clamp(zoom.y + delta.y, min_zoom.y, max_zoom.y))
		last_mouse_position = current_mouse_position
		current_mouse_position = event.position
