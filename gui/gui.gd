extends Control

onready var time_value = $TopPanel/Time/Value

func _on_time_updated(time_passed: float) -> void:
	var seconds := int(time_passed) % 60
	var minutes := int(time_passed / 60.0)
	time_value.text = zero_padding(minutes) + str(minutes) + ":" + zero_padding(seconds) + str(seconds)

func zero_padding(value: int) -> String:
	return "0" if value < 10 else ""
