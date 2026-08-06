extends BaseInputComponent
class_name PlayerInputComponent
@export var radius : float
@export var dead_zone : float
@export var chase_camera : Camera3D
@export var ship : Node3D

func get_chase_camera():
	return chase_camera
#----------Player Thrust Input----------:
func get_thrust_axis():
	return thrust_axis
	
#----Mouse_Steering-----:

func get_mouse_steer():
	var cam = get_chase_camera()
	var center = cam.get_window().size * 0.5
	var mouse_pos = cam.get_viewport().get_mouse_position()
	
	var dist = mouse_pos.distance_to(center)
	dist /= radius
	

	if dist <= dead_zone:
		return Vector3.ZERO

	var mouse_world = cam.project_position(mouse_pos, 100.0)
	

	var mouse_local = ship.global_transform.affine_inverse() * mouse_world


	var forward = Vector3.FORWARD 
	var target_dir = (mouse_local - forward).normalized()

	return target_dir



func set_input_axis():
	thrust_axis.x = Input.get_axis("strafe_left","strafe_right")
	thrust_axis.y = Input.get_axis("lower","raise")
	thrust_axis.z = Input.get_axis("throttle_up","throttle_down")
	radial_thrust_axis.z = Input.get_axis("roll_left","roll_right")
	radial_thrust_axis.x = get_mouse_steer().y
	radial_thrust_axis.y = get_mouse_steer().x
	radial_thrust_axis = radial_thrust_axis.normalized()
	thrust_axis = thrust_axis.normalized()
	
func _process_input():
	set_input_axis()
	

	
	
	


	
