extends Node3D
#can only follow rigidbody ships

class_name ChaseCamera
@export var target : Node3D
@export var look_speed : float
@export	var rot_speed = 1.0
@export var max_follow_distance : float
@export var follow_height : float
@export var max_target_speed : float
@export var pos_speed = 10.0 
@onready var camera_on_target = $Camera3D
var offset : Vector3
var current_transform : Transform3D

func _ready() -> void:
	pass

func chase_target(dt : float):

	var base_offset = Vector3(0.0, follow_height, max_follow_distance)
	

	var local_velocity = target.transform.basis.inverse() * target.linear_velocity
	

	base_offset.y += local_velocity.y * dt * look_speed

	# Find where the camera wants to be in world space
	var target_world_pos = target.global_transform.translated_local(base_offset).origin



	global_position = global_position.lerp(target_world_pos, pos_speed * dt)



func look_target(dt: float):


	var target_quaternion = target.global_transform.basis.get_rotation_quaternion()
	
	var current_quaternion = global_transform.basis.get_rotation_quaternion()
	var next_quaternion = current_quaternion.slerp(target_quaternion, rot_speed * dt)
	
	# Apply the new smoothed rotation back to the camera matrix
	global_transform.basis = Basis(next_quaternion)

func _physics_process(delta: float) -> void:
	top_level = true
	chase_target(delta)
	look_target(delta)
	
	
	
