extends Control

onready var time_value = $TopPanel/Rows/Time/Value
onready var customer_satisfaction_value = $TopPanel/Rows/CustomerSatisfaction/Value

func _on_time_updated(time_passed: float) -> void:
	var seconds := int(time_passed) % 60
	var minutes := int(time_passed / 60.0)
	time_value.text = Global.zero_padding(minutes) + str(minutes) + ":" + Global.zero_padding(seconds) + str(seconds)

func _on_customer_satisfaction_updated(customer_satisfaction: float, customer_satisfaction_rate: float) -> void:
	customer_satisfaction_value.text = \
		Global.format_percent(customer_satisfaction, 1) + \
		" (" + \
		Global.format_rate(customer_satisfaction_rate, 1) + \
		")"
