extends AudioStreamPlayer

var music := preload("res://music/music.ogg")

func _on_music_finished() -> void:
	stream = music
	play()
