extends Node3D

class_name ship_controller
func apply_thrust( thrust_input : Vector3, ship_data: ShipData):
	var thrust_forward = thrust_input.z
	var thrust_strafe = thrust_input.x * ship_data.thrust_strafe
	var thrust_raise = thrust_input.y * ship_data.thrust_vertical
	if thrust_input.z < 0.0:
		thrust_forward = min(thrust_forward,-thrust_forward)* ship_data.thrust_forward;
	else:
		thrust_forward = max(thrust_forward,-thrust_forward) * ship_data.thrust_reverse;
	var thrust = Vector3(thrust_strafe,thrust_raise,thrust_forward)
	return thrust
func limit_speed(ship_velocity : Vector3, ship_data: ShipData):
	var speed = ship_velocity.length()
	var brake_speed = speed - ship_data.max_speed
	var thrust = ship_velocity
	if speed > ship_data.max_speed:
		thrust -= thrust.normalized() * brake_speed
	return thrust
func auto_slow_down(thrust_input : Vector3,ship_velocity : Vector3, ship_data: ShipData):
	var speed = ship_velocity.length()
	var speed_squared = speed * speed
	var drag_force = ship_velocity.normalized() * ship_data.drag_amount *  speed_squared * 0.5
	if thrust_input.length() < 1.0:
		return drag_force
	return Vector3.ZERO
	
		
	

		
	
	
	
	
	
