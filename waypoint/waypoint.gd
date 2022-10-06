tool
extends Position2D

export(Array) var neighbours

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		update()

func _draw() -> void:
	if Engine.editor_hint:
		for neighbour_path in neighbours:
			if neighbour_path == null:
				continue
			var neighbour := get_node_or_null(neighbour_path)
			if neighbour != null:
				draw_line(Vector2.ZERO, to_local(neighbour.global_position), Color.red, 5.0)
