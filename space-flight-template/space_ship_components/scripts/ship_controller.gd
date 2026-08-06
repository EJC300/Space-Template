extends Node3D

class_name ShipComponent

var ship_thrust: Vector3
var ship_steer : Vector3

func update_ship_physics_state(thrust_input: Vector3, steer_input: Vector3, state: PhysicsDirectBodyState3D, ship_data: ShipData):
	var delta = state.step
	

	var ship_basis = state.transform.basis


	var local_velocity = ship_basis.get_rotation_quaternion().inverse() * state.linear_velocity
	var local_angular = ship_basis.get_rotation_quaternion().inverse() * state.angular_velocity


	ship_thrust.z = thrust_input.z * ship_data.thrust_forward
	ship_thrust.y = thrust_input.y * ship_data.thrust_vertical
	ship_thrust.x = thrust_input.x * ship_data.thrust_strafe

	
	local_velocity += ship_thrust * delta


	var drag_x = -local_velocity.x * abs(local_velocity.x) * ship_data.drag_amount
	var drag_y = -local_velocity.y * abs(local_velocity.y) * ship_data.drag_amount
	var drag_z = -local_velocity.z * abs(local_velocity.z) * ship_data.drag_amount
	
	local_velocity += Vector3(drag_x, drag_y, drag_z) * delta


	var limit_z = clampf(local_velocity.z, -ship_data.max_speed, ship_data.max_reverse_speed)
	var limit_x = clampf(local_velocity.x, -ship_data.max_maneuver_speed, ship_data.max_maneuver_speed)
	var limit_y = clampf(local_velocity.y, -ship_data.max_maneuver_speed, ship_data.max_maneuver_speed)
	
	local_velocity.z = lerp(local_velocity.z, limit_z, ship_data.thrust_reverse * delta)
	local_velocity.x = lerp(local_velocity.x, limit_x, ship_data.thrust_reverse * delta)
	local_velocity.y = lerp(local_velocity.y, limit_y, ship_data.thrust_reverse * delta)


	ship_steer.x = steer_input.x * ship_data.thrust_pitch
	ship_steer.y = steer_input.y * ship_data.thrust_yaw
	ship_steer.z = steer_input.z * ship_data.thrust_roll
	

	local_angular += ship_steer * delta
	

	var rot_drag = -local_angular * local_angular.length() * ship_data.angular_drag_amount
	local_angular += rot_drag * delta

	
	if local_angular.length() > ship_data.max_angular_speed:
		local_angular = local_angular.normalized() * ship_data.max_angular_speed

	state.linear_velocity = ship_basis.get_rotation_quaternion() * local_velocity
	state.angular_velocity = ship_basis.get_rotation_quaternion() * local_angular

	
