extends Panel

func _ready() -> void:
	$Text.text = "On the bright side, this is how long you've managed to stay:\n" + Global.format_time(Global.seconds_lasted)

func _on_try_again_pressed() -> void:
	var err := get_tree().change_scene("res://game/game.tscn")
	assert(err == OK)

