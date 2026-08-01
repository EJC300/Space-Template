extends Camera3D
#can only follow rigidbody ships

class_name ChaseCamera

@export var target : Node3D
@export var max_follow_distance : float
#set follow_height to 0 or less than the height of a cockpit
@export var follow_height : float
#max_target_speed effects how far the camera lags behind
@export var max_target_speed : float
var offset : Vector3
var current_transform : Transform3D

func _ready() -> void:
	offset = Vector3(0.0,follow_height,max_follow_distance)

func chase_target(dt : float):
	var xform = target.transform.translated_local(offset)
	var speed = target.linear_velocity.length()
	speed = min(speed,max_target_speed)
	current_transform = global_transform.interpolate_with(xform, speed * dt)
	global_transform = current_transform.orthonormalized()
	

func look_target(dt : float):
	var angular_speed = deg_to_rad( target.linear_velocity.length() / 4.0)
	angular_speed = rad_to_deg( min(angular_speed,max_target_speed * 0.5))
	var direction = (target.global_position  - global_position).normalized()
	var point = transform.translated_local(target.basis.z * 10).origin
	var current_rotation = Quaternion(Vector3.FORWARD,Vector3(direction.x,direction.y,direction.z) + point)
	var new_rotation = transform.basis.slerp(current_rotation,angular_speed * dt)
	transform.basis = new_rotation.orthonormalized()

func _physics_process(delta: float) -> void:
	look_target(delta)
	chase_target(delta)
	
