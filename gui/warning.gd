extends Panel

onready var label := $Label
onready var timer := $Timer

func show_warning(text: String) -> void:
	label.text = text
	timer.start()

	if !visible:
		visible = true
		yield(timer, "timeout")
		visible = false
