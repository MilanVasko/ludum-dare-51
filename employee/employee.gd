extends Node2D

const Waypoint = preload("res://waypoint/waypoint.gd")
const SPEED := 500.0

export(Global.DefectType) var target_defect_type: int

var path_to_travel := []
var current_travel_index := -1

func _process(delta: float) -> void:
	if current_travel_index < 0 || current_travel_index >= path_to_travel.size():
		return
	var target_position: Vector2 = path_to_travel[current_travel_index]
	var rest_of_the_way := target_position - global_position
	var intended_movement := rest_of_the_way.normalized() * SPEED * delta

	if is_zero_approx(intended_movement.length_squared()) || \
	   intended_movement.length_squared() > rest_of_the_way.length_squared():
		intended_movement = rest_of_the_way
		current_travel_index += 1
	global_position += intended_movement

func move_to(global_target_position: Vector2) -> void:
	path_to_travel = find_path_to(global_target_position)
	current_travel_index = 0

func find_path_to(global_target_position: Vector2) -> Array:
	var waypoints := get_tree().get_nodes_in_group("waypoint")
	var neighbour_waypoints := Global.find_neighbour_waypoints(waypoints, global_target_position)
	return find_path_to_impl(
		neighbour_waypoints[0],
		neighbour_waypoints[1],
		Global.find_projected_waypoint(waypoints, global_target_position)
	)

func reconstruct_path(came_from: Dictionary, current: Waypoint, real_target: Vector2) -> Array:
	var total_path := [current.global_position]
	while came_from.has(current):
		current = came_from[current]
		if current.is_inside_tree():
			total_path.push_front(current.global_position)
	total_path.push_back(real_target)
	return total_path

func find_path_to_impl(goal_a: Waypoint, goal_b: Waypoint, real_target: Vector2) -> Array:
	var start := create_initial_waypoint()
	var open_set := [start]

	var came_from := {}

	var score := {}
	score[start] = 0

	while !open_set.empty():
		var current_id := 0
		var current: Waypoint = open_set[current_id]
		if current == goal_a || current == goal_b:
			return reconstruct_path(came_from, current, real_target)

		open_set.remove(current_id)
		for neighbour_path in current.neighbours:
			var neighbour
			if current.is_inside_tree():
				neighbour = current.get_node(neighbour_path)
			else:
				neighbour = get_node(neighbour_path)

			var cgp
			if current.is_inside_tree():
				cgp = current.global_position
			else:
				cgp = global_position

			var tentative_g_score: float = \
				score[current] + cgp.distance_to(neighbour.global_position)

			if tentative_g_score < score.get(neighbour, INF):
				came_from[neighbour] = current
				score[neighbour] = tentative_g_score
				if open_set.find(neighbour) < 0:
					open_set.append(neighbour)

	assert(false, "Could not find path")
	return []

func create_initial_waypoint() -> Waypoint:
	var waypoints := get_tree().get_nodes_in_group("waypoint")
	var neighbours := Global.find_neighbour_waypoints(waypoints, global_position)
	var waypoint_a: Node2D = neighbours[0]
	var waypoint_b: Node2D = neighbours[1]

	var result := Waypoint.new()
	result.neighbours = [waypoint_a.get_path(), waypoint_b.get_path()]
	return result
