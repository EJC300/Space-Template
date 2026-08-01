extends Node3D
class_name ManeuveringThrust

func add_axis_torque(body:RigidBody3D,force : Vector3):
	body.apply_torque(force)
