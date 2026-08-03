extends Node3D

class_name Thruster
var previous_velocity : Vector3
var velocity_error : Vector3

func apply_thrust_forward(input:float, data : ShipData):
	var force = data.thrust_forward * input
	return force
	
func apply_thrust_strafe(input:float, data : ShipData):
	var force =  data.thrust_strafe * input
	return force
	

func apply_thrust_raise(input:float, data : ShipData):
	var force = data.thrust_vertical * input
	return force


func flight_assist_thrust(input_component : float,input_velocity_component: float , data : ShipData):
	var speed = input_velocity_component
	var damp_force_component = 0.5 * (speed * speed) * data.drag_amount
	if speed > data.max_speed or abs(input_component) > 0.0:
		var brake_speed = speed - data.max_speed
	
		 
		var brake_force =  brake_speed*data.max_speed
		return -brake_force
	else:
		return -damp_force_component
	
	
	
	
