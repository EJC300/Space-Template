extends Node3D

class_name BaseInputComponent
var thrust_axis : Vector3
var radial_thrust_axis : Vector3

#----------Player Thrust Input----------:
func get_thrust_axis():
	return thrust_axis
func get_radial_thrust_axis():
	return radial_thrust_axis
func _process_input():
	pass
