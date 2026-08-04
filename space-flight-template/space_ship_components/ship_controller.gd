extends Node3D

class_name ShipComponent
var ship_thrust: Vector3
var ship_steer : Vector3
var final_limited_velocity : Vector3

func update_ship_physics_state(thrust_input : Vector3,steer_input: Vector3,state : PhysicsDirectBodyState3D, ship_data: ShipData):
	var delta = state.step
	var global_rotation_quaternion = state.transform.basis.get_rotation_quaternion()
	var inverse_rotation = global_rotation_quaternion.inverse()
	
	var local_velocity = inverse_rotation * state.linear_velocity
	var local_angular_velocity = inverse_rotation * state.angular_velocity
	
	var speed_squard = pow(state.linear_velocity.length(),2)
	var angular_speed_squard = pow(state.angular_velocity.length(),2)
	var velocity_normalized = state.linear_velocity.normalized()
	var angular_velocity_normalized = state.angular_velocity.normalized()
	var velocity = state.transform.basis.inverse().get_rotation_quaternion()  * state.linear_velocity
	#-----Acclerate with the thrust_input of course throttle
	if thrust_input.z > 0.0:
		ship_thrust.z = thrust_input.z  * ship_data.thrust_forward 
	#----Decelrate with the thrust_input
	elif thrust_input.z < 0.0:
		ship_thrust.z = thrust_input.z * ship_data.thrust_reverse
	
	ship_thrust.y = thrust_input.y * ship_data.thrust_vertical
	ship_thrust.x = thrust_input.x * ship_data.thrust_strafe
	
	#----Arcade Style Drag To Slow Down
	var space_drag = -velocity_normalized * 0.5 * speed_squard * ship_data.drag_amount
	#----Arcade Torque Drag
	var space_rotational_drag = -angular_velocity_normalized * 0.5 * angular_speed_squard * ship_data.angular_drag_amount

	
	
	#-----Turn with steer 
	ship_steer += steer_input* delta
	ship_steer.x *= ship_data.thrust_pitch
	ship_steer.y *= ship_data.thrust_yaw
	ship_steer.z *= ship_data.thrust_roll
	

	
	#----Apply Velocity Directly To State

	local_velocity += (ship_thrust + space_drag) * delta
	local_angular_velocity += (ship_steer + space_rotational_drag) * delta

	
	#----Apply Agnular Velocity Directly To State	
	state.angular_velocity = ship_steer + space_rotational_drag
	state.angular_velocity = state.transform.basis.inverse().get_rotation_quaternion()  *state.angular_velocity
	
		#-----Limit Speed at all axis
	final_limited_velocity.z = clampf(velocity.z,-ship_data.max_reverse_speed,ship_data.max_speed)
	final_limited_velocity.y = clampf(velocity.y,-ship_data.max_maneuver_speed,ship_data.max_maneuver_speed)
	final_limited_velocity.x = clampf(velocity.x,-ship_data.max_maneuver_speed,ship_data.max_maneuver_speed)
	
	local_velocity = lerp(local_velocity, final_limited_velocity, ship_data.thrust_reverse * delta)

	#----Limit rotation Speed
	if local_angular_velocity.length() > ship_data.max_angular_speed:
		local_angular_velocity = local_angular_velocity.normalized() * ship_data.max_angular_speed
	
	state.linear_velocity = global_rotation_quaternion * local_velocity
	state.angular_velocity = global_rotation_quaternion * local_angular_velocity
	print(state.linear_velocity)
