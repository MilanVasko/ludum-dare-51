extends Node2D

func _on_sprite_clicked(_event: InputEventMouseButton) -> void:
	get_tree().call_group("employee_click_subscriber", "_on_employee_unselected")
