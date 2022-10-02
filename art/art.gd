extends Node2D

export(Array) var textures: Array

func _ready() -> void:
	$Sprite.texture = textures[randi() % textures.size()]
