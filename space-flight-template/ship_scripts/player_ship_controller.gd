extends RigidBody3D
class_name PlayerShipController
@export var data : ShipData
@export var radius : float
@export var dead_zone : float
@onready var ship_controller_component = $ShipControler
var thrust_axis : Vector3
var radial_thrust_axis : Vector3
var chase_camera : Camera3D


func _ready() -> void:
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp = 0.0

	if !chase_camera:
		chase_camera = get_viewport().get_camera_3d()
#-------Get Ship Data--------:
func get_ship_data():
	return data

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
	var cursor_ship_local_position = basis * mouse_world_position
	var ship_forward = basis * global_basis.z
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
	radial_thrust_axis.x = get_mouse_steer().x
	radial_thrust_axis.y = get_mouse_steer().y
	radial_thrust_axis = radial_thrust_axis.normalized()
	thrust_axis = thrust_axis.normalized()
	

func _process(_delta: float) -> void:
	set_input_axis()
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var delta = Engine.get_physics_ticks_per_second()/36000.0
	state.linear_velocity += global_basis * ship_controller_component.apply_thrust(get_thrust_axis(),get_ship_data()) * delta
	state.linear_velocity = global_basis * ship_controller_component.limit_speed(state.linear_velocity,get_ship_data())
	state.linear_velocity -= global_basis * ship_controller_component.auto_slow_down(thrust_axis,state.linear_velocity,get_ship_data()) * delta
	
	
	
	


	
