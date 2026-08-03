extends RigidBody3D
class_name PlayerShipController
@export var data : ShipData
@onready var thruster = $Thruster
var thrust_direction : Vector3
var thrust_axis : Vector3

func _ready() -> void:
	
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp = 0.0
func thrust_input():
	var input_thrust = Input.get_axis("throttle_up","throttle_down")
	var input_thrust_raise = Input.get_axis("raise","lower")
	var input_thrust_strafe = Input.get_axis("strafe_left","strafe_right")
	thrust_direction = Vector3(input_thrust_strafe,input_thrust_raise,input_thrust)
	thrust_direction = thrust_direction.normalized()
func apply_thrust_assist(state: PhysicsDirectBodyState3D):
	var axis_z = thruster.flight_assist_thrust(thrust_direction.z,state.linear_velocity.z,data)
	var axis_y = thruster.flight_assist_thrust(thrust_direction.y,state.linear_velocity.y,data)
	var axis_x = thruster.flight_assist_thrust(thrust_direction.x,state.linear_velocity.x,data)
	return Vector3(axis_x,axis_y,axis_z)
func thrust():
	thrust_axis.z =	thruster.apply_thrust_forward(thrust_direction.z,data)
	thrust_axis.y = thruster.apply_thrust_raise(thrust_direction.y,data)
	thrust_axis.x = thruster.apply_thrust_strafe(thrust_direction.x,data)
func maneuver_thrust():
	pass
func _process(_delta: float) -> void:
	thrust_input()
func _physics_process(_delta: float) -> void:
	thrust();

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var thrust_assist = apply_thrust_assist(state)
	var thrust_forces_integrated = thrust_axis 
	print(thrust_assist)
	state.apply_central_force(thrust_assist)
	state.apply_central_force(thrust_forces_integrated)
	
	
	print(state.linear_velocity.length())
	
