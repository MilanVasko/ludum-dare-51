extends PanelContainer

func _on_try_again_pressed():
	var err := get_tree().change_scene("res://main.tscn")
	assert(err == OK)

