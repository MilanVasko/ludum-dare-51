extends Node2D

export(Array) var textures: Array
export(Array) var texture_colors: Array

onready var progress_bar: ProgressBar = $ProgressBar/ProgressBar

var assigned_employee: Node2D = null
var severity: float = 5.0
var current_severity: float

var visible_cooldown := -1.0

func _ready() -> void:
	var sprite := $Sprite
	sprite.texture = textures[randi() % textures.size()]
	sprite.modulate = texture_colors[randi() % texture_colors.size()]
	
	sprite.rotation_degrees = rand_range(0.0, 360.0)

	progress_bar.visible = false
	current_severity = severity
	get_tree().call_group("defect_life_subscriber", "_on_defect_spawned", self)

func _process(delta: float) -> void:
	if visible_cooldown > 0.0:
		visible_cooldown -= delta
		if visible_cooldown <= 0.0:
			$Indicator.visible = false

	if assigned_employee != null:
		progress_bar.value = 1.0 - (current_severity / severity)
		current_severity -= delta
		if current_severity <= 0.0:
			get_tree().call_group("defect_life_subscriber", "_on_defect_fixed", self)
			queue_free()

func _on_sprite_clicked(_event: InputEventMouseButton) -> void:
	get_tree().call_group("defect_click_subscriber", "_on_defect_clicked", self)

func highlight_on_click() -> void:
	$Indicator.visible = true
	visible_cooldown = 2.0

func assign_employee(employee: Node2D) -> void:
	assigned_employee = employee
	progress_bar.visible = true

func accepts_employee(employee: Node2D) -> bool:
	return assigned_employee == null || assigned_employee == employee


