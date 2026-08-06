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
	

func look_target(dt : float):
	var direction = (target.global_position  - global_position).normalized()
	var world_up_dir = target.transform.basis.y.cross(Vector3.RIGHT)
	world_up_dir =target.basis.get_rotation_quaternion() * world_up_dir.lerp(Vector3.UP,dt * world_up_change_speed)
	var current_rotation =  Basis.looking_at(direction,world_up_dir)
	var new_rotation = current_rotation
	camera_on_target.look_at(target.global_position +target.basis.get_rotation_quaternion() *target.basis.z * -2,world_up_dir)
	global_transform.basis = global_transform.basis.slerp( new_rotation,look_speed * dt)
func _physics_process(delta: float) -> void:
	chase_target(delta)
	look_target(delta)
	
	
	
