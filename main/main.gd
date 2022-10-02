extends Control

func _ready() -> void:
	$Play.grab_focus()

func _on_play_pressed() -> void:
	var err := get_tree().change_scene("res://story/story.tscn")
	assert(err == OK)
