extends Node2D

export(Global.DefectType) var defect_type: int

func _on_sprite_clicked(_event: InputEventMouseButton) -> void:
	get_tree().call_group("defect_click_subscriber", "_on_defect_clicked", self)
