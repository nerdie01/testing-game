extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_context"):
		visible = !visible
		position = get_global_mouse_position()
