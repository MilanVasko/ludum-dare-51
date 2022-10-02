extends Node2D

export(float) var self_destruct_time: float

var accum := 0.0

func _process(delta: float) -> void:
	accum += delta
	scale = Vector2.ONE + (Vector2.ONE * sin(accum * 10.0) * 0.15)

	self_destruct_time -= delta
	if self_destruct_time <= 0.0:
		queue_free()
