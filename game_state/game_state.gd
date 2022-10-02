extends Node

export(NodePath) var employee_container_path: NodePath

export(float) var customer_satisfaction_deterioration_speed_min: float
export(float) var customer_satisfaction_deterioration_speed_max: float
export(Curve) var customer_satisfaction_deterioration_curve: Curve

export(float) var money_speed_min: float
export(float) var money_speed_max: float
export(Curve) var money_speed_curve: Curve

export(float) var employee_cost: float
export(float) var employee_cost_rise: float

onready var employee_container: Node = get_node(employee_container_path)

var defect_spawn_count: int

var current_defects := 0
var time_passed := 0.0
var current_customer_satisfaction := 1.0
var current_customer_satisfaction_deterioration_rate := 0.0

var current_money := 0.0

func _ready() -> void:
	defect_spawn_count = get_tree().get_nodes_in_group("defect_spawn").size()
	update_customer_satisfaction_rate()
	debug_print()

	get_tree().call_group("time_subscriber", "_on_time_updated", time_passed)
	get_tree().call_group("customer_satisfaction_subscriber", "_on_customer_satisfaction_updated", current_customer_satisfaction, -current_customer_satisfaction_deterioration_rate)
	get_tree().call_group("money_subscriber", "_on_money_updated", current_money, employee_cost)
	get_tree().call_group("employee_cost_subscriber", "_on_employee_cost_changed", employee_cost)

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
		Global.seconds_lasted = time_passed
		var err := get_tree().change_scene("res://game_over/game_over.tscn")
		assert(err == OK)

	current_money += lerp(
		money_speed_min,
		money_speed_max,
		money_speed_curve.interpolate(current_customer_satisfaction)
	) * delta

	get_tree().call_group("time_subscriber", "_on_time_updated", time_passed)
	get_tree().call_group("customer_satisfaction_subscriber", "_on_customer_satisfaction_updated", current_customer_satisfaction, -current_customer_satisfaction_deterioration_rate)
	get_tree().call_group("money_subscriber", "_on_money_updated", current_money, employee_cost)

func _on_employee_buy_requested() -> void:
	if current_money < employee_cost:
		return
	current_money -= employee_cost
	employee_cost += employee_cost_rise
	get_tree().call_group("employee_cost_subscriber", "_on_employee_cost_changed", employee_cost)

	spawn_employee()
	get_tree().call_group("money_subscriber", "_on_money_updated", current_money, employee_cost)

func spawn_employee() -> void:
	var spawn_points := get_tree().get_nodes_in_group("employee_spawn")
	var spawn_point: Node2D = spawn_points[randi() % spawn_points.size()]
	var employee_scene := load("res://employee/employee.tscn")
	var employee_instance = employee_scene.instance()
	employee_container.add_child(employee_instance)
	employee_instance.global_position = spawn_point.global_position

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
