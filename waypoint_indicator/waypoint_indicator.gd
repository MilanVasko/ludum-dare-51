extends Node2D

export(float) var self_destruct_time: float

var accum := 0.0

func _ready() -> void:
	var timer := $Timer
	timer.start(self_destruct_time)
	yield(timer, "timeout")
	queue_free()

func _process(delta: float) -> void:
	accum += delta
	scale = Vector2.ONE + (Vector2.ONE * sin(accum * 10.0) * 0.15)
