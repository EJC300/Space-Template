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
	var delta = Engine.get_physics_ticks_per_second() * Engine.get_physics_ticks_per_second()
	var center_screen = get_chase_camera().get_window().size * 0.5
	var mouse_position_screen = get_chase_camera().get_viewport().get_mouse_position()
	var distance = mouse_position_screen.distance_to(center_screen)
	distance /= radius
	var mouse_world_position = get_chase_camera().project_position(mouse_position_screen,100.0)
	var cursor_ship_local_position =ship.basis.inverse().get_rotation_quaternion() * mouse_world_position
	var ship_forward = ship.basis.z
	var direction = (cursor_ship_local_position - ship_forward)

	if distance > dead_zone:
		return direction.normalized()
	else:
		cursor_ship_local_position = cursor_ship_local_position.move_toward(Vector3.ZERO,delta)
	return Vector3.ZERO


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
	

	
	
	


	
