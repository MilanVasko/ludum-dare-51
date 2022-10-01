extends Sprite

export(bool) var consume_input: bool

signal on_sprite_clicked

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == BUTTON_LEFT:
			var rect: Rect2 = get_global_transform().xform(get_rect())
			if rect.has_point(get_global_mouse_position()):
				var connections := get_signal_connection_list("on_sprite_clicked")
				if !connections.empty():
					emit_signal("on_sprite_clicked", event)
					if consume_input:
						get_tree().set_input_as_handled()
