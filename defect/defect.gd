extends Node2D

export(Global.DefectType) var defect_type: int

onready var progress_bar: ProgressBar = $ProgressBar/ProgressBar

var assigned_employee: Node2D = null
var severity: float = 5.0
var current_severity: float

func _ready() -> void:
	progress_bar.visible = false
	current_severity = severity
	get_tree().call_group("defect_life_subscriber", "_on_defect_spawned")

func _process(delta: float) -> void:
	if assigned_employee != null:
		progress_bar.value = 1.0 - (current_severity / severity)
		current_severity -= delta
		if current_severity <= 0.0:
			get_tree().call_group("defect_life_subscriber", "_on_defect_fixed")
			queue_free()

func _on_sprite_clicked(_event: InputEventMouseButton) -> void:
	get_tree().call_group("defect_click_subscriber", "_on_defect_clicked", self)

func assign_employee(employee: Node2D) -> void:
	assigned_employee = employee
	progress_bar.visible = true

func accepts_employee(employee: Node2D) -> bool:
	return assigned_employee == null || assigned_employee == employee
