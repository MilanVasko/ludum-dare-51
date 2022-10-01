extends Camera2D

var dragging := false
var last_mouse_position: Vector2
var current_mouse_position: Vector2
export(Vector2) var min_zoom: Vector2
export(Vector2) var max_zoom: Vector2

var selected_employee: Node2D = null

func _process(_delta: float) -> void:
	if dragging:
		position -= (current_mouse_position - last_mouse_position) * zoom
		last_mouse_position = current_mouse_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event is InputEventMouseButton:
			dragging = event.pressed && event.button_index in [BUTTON_MIDDLE, BUTTON_RIGHT]
			if event.button_index == BUTTON_WHEEL_UP:
				zoom = Vector2(clamp(zoom.x - 1, min_zoom.x, max_zoom.x), clamp(zoom.y - 1, min_zoom.y, max_zoom.y))
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoom = Vector2(clamp(zoom.x + 1, min_zoom.x, max_zoom.x), clamp(zoom.y + 1, min_zoom.y, max_zoom.y))
		last_mouse_position = current_mouse_position
		current_mouse_position = event.position

func _on_defect_clicked(defect: Node2D) -> void:
	if selected_employee == null:
		print("An employee must be selected!")
		return

	selected_employee.go_and_fix(defect)
	_on_employee_selected(null)

func _on_employee_move(target_global_position: Vector2) -> void:
	if selected_employee != null:
		selected_employee.move_to(target_global_position)
		_on_employee_selected(null)

func _on_employee_selected(employee: Node2D) -> void:
	if selected_employee != null:
		selected_employee.unselect()

	if selected_employee != employee:
		selected_employee = employee
		if selected_employee != null:
			selected_employee.select()
	else:
		selected_employee = null
