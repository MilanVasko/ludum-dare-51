extends Node

export(float) var initial_peace_time: float
export(float) var new_defect_spawn_time_min: float
export(float) var new_defect_spawn_time_range: float
export(float) var harder_spawn_time_after: float
export(float) var harder_spawn_time_difference: float
export(float) var hardest_spawn_time: float
export(float) var severity_min: float
export(float) var severity_max: float

onready var spawns := get_tree().get_nodes_in_group("defect_spawn")

onready var spawn_cooldown := initial_peace_time
onready var harder_cooldown := initial_peace_time + harder_spawn_time_after

func _ready() -> void:
	get_tree().call_group("difficulty_subscriber", "_on_difficulty_updated", self)

func _process(delta: float) -> void:
	process_spawn(delta)
	process_harder_difficulty(delta)

func process_spawn(delta: float) -> void:
	spawn_cooldown -= delta
	if spawn_cooldown <= 0.0:
		spawn_cooldown = rand_range(
			new_defect_spawn_time_min,
			new_defect_spawn_time_min + new_defect_spawn_time_range
		)
		spawn_defect()

func process_harder_difficulty(delta: float) -> void:
	harder_cooldown -= delta
	if harder_cooldown <= 0.0:
		harder_cooldown = harder_spawn_time_after
		new_defect_spawn_time_min = max(
			new_defect_spawn_time_min - harder_spawn_time_difference,
			hardest_spawn_time
		)
		get_tree().call_group("difficulty_subscriber", "_on_difficulty_updated", self)

func spawn_defect() -> void:
	var current_defects := get_tree().get_nodes_in_group("defect")
	assert(current_defects.size() <= spawns.size())
	var free_spots := spawns.size() - current_defects.size()
	if free_spots == 0:
		print("Can not spawn defect - already at full capacity.")
		return
	print("Free spots: ", free_spots)

	var spawn_index := randi() % free_spots
	var i := 0
	for s in spawns:
		var spawn: Node2D = s
		if spawn.get_child_count() == 0:
			if i == spawn_index:
				spawn_defect_at(spawn)
				return
			i += 1

	assert(false, "Defect should have been spawned by now.")

func spawn_defect_at(spawn: Node2D) -> void:
	print("Spawning at ", spawn)
	var defect_scene := preload("res://defect/defect.tscn")
	var defect_scene_instance := defect_scene.instance()
	defect_scene_instance.severity = rand_range(severity_min, severity_max)
	spawn.add_child(defect_scene_instance)
