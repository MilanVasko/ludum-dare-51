extends Node

export(float) var customer_satisfaction_deterioration_speed_min: float
export(float) var customer_satisfaction_deterioration_speed_max: float
export(Curve) var customer_satisfaction_deterioration_curve: Curve

var defect_spawn_count: int

var current_defects := 0
var time_passed := 0.0
var current_customer_satisfaction := 1.0
var current_customer_satisfaction_deterioration_rate := 0.0

func _ready() -> void:
	defect_spawn_count = get_tree().get_nodes_in_group("defect_spawn").size()
	update_customer_satisfaction_rate()
	debug_print()

	get_tree().call_group("time_subscriber", "_on_time_updated", time_passed)
	get_tree().call_group("customer_satisfaction_subscriber", "_on_customer_satisfaction_updated", current_customer_satisfaction, -current_customer_satisfaction_deterioration_rate)

func debug_print() -> void:
	var i = 0
	while i < defect_spawn_count:
		print(
			Global.zero_padding(i+0), i+0, ": ", Global.format_rate(calculate_deterioration_rate(i+0), 1), "\t\t",
			Global.zero_padding(i+1), i+1, ": ", Global.format_rate(calculate_deterioration_rate(i+1), 1), "\t\t",
			Global.zero_padding(i+2), i+2, ": ", Global.format_rate(calculate_deterioration_rate(i+2), 1), "\t\t",
			Global.zero_padding(i+3), i+3, ": ", Global.format_rate(calculate_deterioration_rate(i+3), 1), "\t\t",
			Global.zero_padding(i+4), i+4, ": ", Global.format_rate(calculate_deterioration_rate(i+4), 1), "\t\t"
		)
		i += 5

func _process(delta: float) -> void:
	time_passed += delta
	current_customer_satisfaction = min(current_customer_satisfaction - current_customer_satisfaction_deterioration_rate * delta, 1.0)
	if current_customer_satisfaction < 0.0:
		var err := get_tree().change_scene("res://game_over/game_over.tscn")
		assert(err == OK)
	get_tree().call_group("time_subscriber", "_on_time_updated", time_passed)
	get_tree().call_group("customer_satisfaction_subscriber", "_on_customer_satisfaction_updated", current_customer_satisfaction, -current_customer_satisfaction_deterioration_rate)

func _on_defect_spawned() -> void:
	current_defects += 1
	update_customer_satisfaction_rate()
	assert(current_defects >= 0 && current_defects <= defect_spawn_count)

func _on_defect_fixed() -> void:
	current_defects -= 1
	update_customer_satisfaction_rate()
	assert(current_defects >= 0 && current_defects <= defect_spawn_count)

func update_customer_satisfaction_rate() -> void:
	current_customer_satisfaction_deterioration_rate = calculate_deterioration_rate(current_defects)
	get_tree().call_group("customer_satisfaction_subscriber", "_on_customer_satisfaction_updated", current_customer_satisfaction, -current_customer_satisfaction_deterioration_rate)

func calculate_deterioration_rate(defects: int) -> float:
	var t := customer_satisfaction_deterioration_curve.interpolate(
		float(defects) / float(defect_spawn_count)
	)
	return lerp(customer_satisfaction_deterioration_speed_min, customer_satisfaction_deterioration_speed_max, t)
