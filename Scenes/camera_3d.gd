extends Camera3D

var target_pos

@export var auto_offset: bool = true
@export var offset: Vector3

func _ready() -> void:
	if auto_offset:
		offset = position - Global.character.position
		
func _physics_process(delta: float) -> void:
	target_pos = Global.character.position + offset
	position = position.lerp(target_pos, 5 * delta)
