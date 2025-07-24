extends PhysicalBoneSimulator3D

var physics_bones: Array[Node]
@export var copy_skeleton: Skeleton3D
@export var angular_spring_stiffness: float = 2000.0
@export var angular_spring_damping: float = 80.0
@export var max_angular_force: float = 9999.0

func _ready() -> void:
	physics_bones = get_children().filter(func(x): return x is PhysicalBone3D)
	for bone: PhysicalBone3D in physics_bones:
		print(bone.name, copy_skeleton.get_bone_name(bone.get_bone_id()))
	
func _process(delta: float) -> void:
	physical_bones_start_simulation()
	for bone: PhysicalBone3D in physics_bones:
		var target_pos: Vector3 = copy_skeleton.get_bone_pose_position(bone.get_bone_id())
		var target_rot := copy_skeleton.get_bone_pose_rotation(bone.get_bone_id()).get_euler()
		
		bone.position = target_pos
		bone.rotation = target_rot

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)
