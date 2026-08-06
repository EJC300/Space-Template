extends Node3D
#can only follow rigidbody ships

class_name ChaseCamera

@export var target : Node3D
@export var world_up_change_speed : float
@export var look_speed : float
@export var max_follow_distance : float
#set follow_height to 0 or less than the height of a cockpit
@export var follow_height : float
#max_target_speed effects how far the camera lags behind
@export var max_target_speed : float
@onready var camera_on_target = $Camera3D
var offset : Vector3
var current_transform : Transform3D

func _ready() -> void:
	pass

func chase_target(dt : float):
	offset = Vector3(0.0,follow_height,max_follow_distance)
	offset.y += target.linear_velocity.y * dt * look_speed
	
	var xform = target.transform.translated_local(offset + target.basis.get_rotation_quaternion() *target.basis.z)
	var speed = target.linear_velocity.length()
	speed = clampf(speed,0.5,max_target_speed)
	current_transform = global_transform.interpolate_with(xform, speed * dt)
	global_transform = current_transform
	

func look_target(dt: float):

	var to_target = target.global_position - global_position
	if to_target.is_zero_approx():
		return
	var direction = to_target.normalized()
	
	var world_up_dir = target.global_basis.y
	

	var target_basis = Basis.looking_at(direction, world_up_dir)
	

	global_basis = global_basis.slerp(target_basis, look_speed * dt).orthonormalized()
	

	var target_chase_pos = target.global_position + (target.global_basis.z * 15.0) + (target.global_basis.y * 3.0)
	global_position = global_position.lerp(target_chase_pos, look_speed * dt)

func _physics_process(delta: float) -> void:
	top_level = true
	chase_target(delta)
	look_target(delta)
	
	
	
