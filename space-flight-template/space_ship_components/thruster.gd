extends Node3D

class_name Thruster

func add_thrust(body:RigidBody3D,force : Vector3):
	body.apply_central_force(force)
	


	
