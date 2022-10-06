extends Node

# TODO: refactor this global variable someday?
var seconds_lasted: float

func _ready():
	randomize()

func find_projected_waypoint(waypoints: Array, global_position: Vector2) -> Vector2:
	var neighbours := find_neighbour_waypoints(waypoints, global_position)
	var waypoint_a: Vector2 = neighbours[0].global_position
	var waypoint_b: Vector2 = neighbours[1].global_position
	var d := global_position - waypoint_a
	return waypoint_a + d.project(waypoint_b - waypoint_a)

func find_neighbour_waypoints(waypoints: Array, global_position: Vector2) -> Array:
	var closest_waypoint := find_closest_waypoint(waypoints, global_position)
	if closest_waypoint == null:
		return []

	var neighbour_waypoint := find_neighbour_to_closest_waypoint(closest_waypoint, global_position)
	if neighbour_waypoint.global_position.x < closest_waypoint.global_position.x:
		return [neighbour_waypoint, closest_waypoint]
	return [closest_waypoint, neighbour_waypoint]

func find_closest_waypoint(waypoints: Array, global_position: Vector2) -> Node2D:
	var closest_waypoint = null
	for w in waypoints:
		var waypoint: Node2D = w
		if waypoint.global_position.y > global_position.y - 5.0:
			if closest_waypoint == null:
				closest_waypoint = waypoint
				continue
			if is_closer(waypoint, closest_waypoint, global_position):
				closest_waypoint = waypoint

	return closest_waypoint

func find_neighbour_to_closest_waypoint(closest_waypoint: Node2D, global_position: Vector2) -> Node2D:
	var closest_direction_to_us := closest_waypoint.global_position.direction_to(global_position)
	var biggest_dot := -INF
	var biggest_dot_neighbour: Node2D = null
	for second_neighbour_path in closest_waypoint.neighbours:
		var second_neighbour: Node2D = closest_waypoint.get_node(second_neighbour_path)
		var neighbour_direction := closest_waypoint.global_position.direction_to(second_neighbour.global_position)
		var current_dot := closest_direction_to_us.dot(neighbour_direction)
		if current_dot > biggest_dot:
			biggest_dot = current_dot
			biggest_dot_neighbour = second_neighbour

	assert(biggest_dot_neighbour != null)
	return biggest_dot_neighbour

func is_closer(a: Node2D, b: Node2D, global_position: Vector2) -> bool:
	return a.global_position.distance_squared_to(global_position) < \
		   b.global_position.distance_squared_to(global_position)

func format_percent(value: float, precision: int) -> String:
	return format_number(value * 100, precision) + "%"

func format_number(value: float, precision: int) -> String:
	var p := int(pow(10, precision))
	var expanded := int(abs(value * p))
	return ("-" if value < 0.0 else "") + str(int(expanded / float(p))) + "." + str(expanded % p)

func format_rate(rate: float, precision: int) -> String:
	return ("+" if rate > 0.0 else "") + format_percent(rate, precision)

func format_time(time: float) -> String:
	var seconds := int(time) % 60
	var minutes := int(time / 60.0)
	return zero_padding(minutes) + str(minutes) + ":" + zero_padding(seconds) + str(seconds)

func zero_padding(value: int) -> String:
	return "0" if value < 10 else ""
