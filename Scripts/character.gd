extends CharacterBody3D
enum States {IDLE, WALK, RUN}

var state: States = States.IDLE
var target_pos: Vector3
var is_jumping: bool = false

@export var speed: float = 1000
@export var sprint_speed: float = 2000
@export var jump_force: float = 300
@export var animation_tree: AnimationTree
@export var look_dir = Vector3.FORWARD

func _ready() -> void:
	target_pos = position
	Global.character = self

func _physics_process(delta: float) -> void:
	var input: Vector3 = Vector3(Input.get_axis("player_left", "player_right"), 0, Input.get_axis("player_up", "player_down")).normalized()
	target_pos = input * delta * sprint_speed if Input.is_action_pressed("player_sprint") else input * delta * speed
	velocity = velocity.lerp(target_pos, 25 * delta)
	
	if target_pos.length() > 0.01:
		look_dir = look_dir.lerp(position - Vector3(target_pos), 25 * delta)
		state = States.RUN if Input.is_action_pressed("player_sprint") else States.WALK
	else:
		state = States.IDLE
	
	if look_dir != Vector3.ZERO:
		look_dir.y = global_position.y
	
	move_and_slide()
	
	if is_on_floor():
		if Input.is_action_just_pressed("player_jump"):
			is_jumping = true
			velocity.y += jump_force
		else:
			is_jumping = false
	else:
		velocity.y += get_gravity().y
	
	if look_dir != position:
		look_at(look_dir)

func _process(delta: float) -> void:
	pass
