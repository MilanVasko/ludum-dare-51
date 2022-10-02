extends Control

func _ready() -> void:
	$Panel/Start.grab_focus()

func _on_play_pressed() -> void:
	var err := get_tree().change_scene("res://game/game.tscn")
	assert(err == OK)

func _on_main_menu_pressed() -> void:
	var err := get_tree().change_scene("res://main/main.tscn")
	assert(err == OK)
