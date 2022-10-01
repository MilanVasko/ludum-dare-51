extends Node

var time_passed := 0.0

func _process(delta: float) -> void:
	time_passed += delta
	get_tree().call_group("time_subscriber", "_on_time_updated", time_passed)
