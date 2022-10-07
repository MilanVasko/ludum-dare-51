extends Control

const DefectSpawner = preload("res://defect_spawner/defect_spawner.gd")

onready var time_value = $TopPanel/Rows/Time/Value
onready var customer_satisfaction_value = $TopPanel/Rows/CustomerSatisfaction/Value
onready var money_value = $MoneyPanel/Money/Value
onready var new_employee_button = $NewEmployee
onready var difficulty_value = $DifficultyPanel/Value
onready var warning := $Warning

func _on_employee_cost_changed(new_employee_cost: float) -> void:
	new_employee_button.text = "+1 New employee (" + str(new_employee_cost) + " coins)"

func _on_new_employee_pressed() -> void:
	get_tree().call_group("buy_subscriber", "_on_employee_buy_requested")

func _on_time_updated(time_passed: float) -> void:
	time_value.text = Global.format_time(time_passed)

func _on_no_employee_selected() -> void:
	warning.show_warning("An employee must be selected to fix something!")

func _on_employee_defect_fix_conflict() -> void:
	warning.show_warning("An employee is already fixing this!")

func _on_customer_satisfaction_updated(customer_satisfaction: float, customer_satisfaction_rate: float) -> void:
	customer_satisfaction_value.text = \
		Global.format_percent(customer_satisfaction, 1) + \
		" (" + \
		Global.format_rate(customer_satisfaction_rate, 1) + \
		")"

func _on_money_updated(money: float, employee_cost: float) -> void:
	money_value.text = Global.format_number(money, 1)
	new_employee_button.disabled = money < employee_cost

func _on_difficulty_updated(defect_spawner: DefectSpawner) -> void:
	difficulty_value.text = \
		"initial_peace_time: " + str(defect_spawner.initial_peace_time) + "\n" + \
		"new_defect_spawn_time_min: " + str(defect_spawner.new_defect_spawn_time_min) + "\n" + \
		"new_defect_spawn_time_range: " + str(defect_spawner.new_defect_spawn_time_range) + "\n" + \
		"harder_spawn_time_after: " + str(defect_spawner.harder_spawn_time_after) + "\n" + \
		"harder_spawn_time_difference: " + str(defect_spawner.harder_spawn_time_difference) + "\n" + \
		"hardest_spawn_time: " + str(defect_spawner.hardest_spawn_time) + "\n" + \
		"severity_min: " + str(defect_spawner.severity_min) + "\n" + \
		"severity_max: " + str(defect_spawner.severity_max) + "\n"

