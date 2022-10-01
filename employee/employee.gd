extends Node2D

export(NodePath) var test_target_node_path
onready var test_target_node: Node2D = get_node(test_target_node_path)
const SPEED := 500.0

export(Global.DefectType) var target_defect_type: int

var path_to_travel := []
var current_travel_index := -1

func _ready() -> void:
	print("Current position: ", global_position)
	print("Test target node: ", test_target_node.global_position)
	move_to(test_target_node.global_position)

func _process(delta: float) -> void:
	if current_travel_index < 0 || current_travel_index >= path_to_travel.size():
		return
	var target_position: Vector2 = path_to_travel[current_travel_index]
	var rest_of_the_way := target_position - global_position
	var intended_movement := rest_of_the_way.normalized() * SPEED * delta
	if intended_movement.length_squared() > rest_of_the_way.length_squared():
		intended_movement = rest_of_the_way
		current_travel_index += 1
	global_position += intended_movement

func move_to(global_target_position: Vector2) -> void:
	path_to_travel = find_path_to(global_target_position)
	current_travel_index = 0

func find_path_to(global_target_position: Vector2) -> Array:
	print("Finding path")
	return [test_target_node.global_position]
