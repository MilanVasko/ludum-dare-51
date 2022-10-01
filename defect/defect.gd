extends Node2D

class_name Defect

export(Global.DefectType) var defect_type: int

func _ready() -> void:
	print(find_neighbour_waypoints())

func find_neighbour_waypoints() -> Array:
	var waypoints = get_tree().get_nodes_in_group("waypoint")
	var closest_waypoint := find_closest_waypoint(waypoints)
	var neighbour_waypoint := find_neighbour_to_closest_waypoint(closest_waypoint)
	if neighbour_waypoint.global_position.x < closest_waypoint.global_position.x:
		return [neighbour_waypoint, closest_waypoint]
	return [closest_waypoint, neighbour_waypoint]

func find_closest_waypoint(waypoints: Array) -> Node2D:
	var closest_waypoint = null
	for w in waypoints:
		var waypoint: Node2D = w
		if waypoint.global_position.y > global_position.y:
			if closest_waypoint == null:
				closest_waypoint = waypoint
				continue
			if is_closer(waypoint, closest_waypoint):
				closest_waypoint = waypoint
	return closest_waypoint

func find_neighbour_to_closest_waypoint(closest_waypoint: Node2D) -> Node2D:
	var closest_direction_to_us := closest_waypoint.global_position.direction_to(global_position)
	var biggest_dot := -INF
	var biggest_dot_neighbour: Node2D = null
	for second_neighbour_path in closest_waypoint.neighbours:
		var second_neighbour: Node2D = closest_waypoint.get_node(second_neighbour_path)
		var current_direction_to_us := second_neighbour.global_position.direction_to(global_position)
		var neighbour_direction := closest_waypoint.global_position.direction_to(second_neighbour.global_position)
		var current_dot := closest_direction_to_us.dot(neighbour_direction)
		if current_dot > biggest_dot:
			biggest_dot = current_dot
			biggest_dot_neighbour = second_neighbour

	assert(biggest_dot_neighbour != null)
	return biggest_dot_neighbour

func is_closer(a: Node2D, b: Node2D) -> bool:
	return a.global_position.distance_squared_to(global_position) < \
		   b.global_position.distance_squared_to(global_position)
