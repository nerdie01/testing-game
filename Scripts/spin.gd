extends Node3D

@export var rotation_vector: Vector3 = Vector3.UP * 0.1

func _physics_process(delta: float) -> void:
	rotation += rotation_vector * delta
