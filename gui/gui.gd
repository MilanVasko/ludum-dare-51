extends Control

onready var time_value = $TopPanel/Rows/Time/Value
onready var customer_satisfaction_value = $TopPanel/Rows/CustomerSatisfaction/Value
onready var money_value = $MoneyPanel/Money/Value
onready var new_employee_button = $NewEmployee

func _ready() -> void:
	new_employee_button.text = "+1 New employee (" + str(find_employee_cost()) + " coins)"

func _on_new_employee_pressed():
	get_tree().call_group("buy_subscriber", "_on_employee_buy_requested")

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

func _on_money_updated(money: float) -> void:
	money_value.text = Global.format_number(money, 1)
	new_employee_button.disabled = money < find_employee_cost()

func find_employee_cost() -> float:
	var game_states := get_tree().get_nodes_in_group("game_state")
	assert(game_states.size() == 1)
	return game_states[0].employee_cost
