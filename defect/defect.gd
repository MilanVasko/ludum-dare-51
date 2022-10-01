extends Node2D

export(Global.DefectType) var defect_type: int

var assigned_employee: Node2D = null
var severity: float

func _ready():
	severity = rand_range(1.0, 10.0)

func _process(delta: float) -> void:
	if assigned_employee != null:
		print("Fixing... ", severity)
		severity -= delta
		if severity <= 0.0:
			queue_free()

func _on_sprite_clicked(_event: InputEventMouseButton) -> void:
	get_tree().call_group("defect_click_subscriber", "_on_defect_clicked", self)

func assign_employee(employee: Node2D) -> void:
	assigned_employee = employee

func accepts_employee(employee: Node2D) -> bool:
	return assigned_employee == null || assigned_employee == employee
