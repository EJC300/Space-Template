@tool
extends Node3D
#Helper To Create Ship Models To Spawn On SpaceShip Factories

class_name ShipModel

func create_ship_model(mesh_name : String):
	var mesh_path = "res://ship_models/" + mesh_name
	var ship_mesh = load(mesh_path)
	var ship_instance = ship_mesh.instantiate()
	return ship_instance
func create_ship_collider():
	
	var ship_collider : CollisionShape3D

	var box_collider = BoxShape3D.new()
	ship_collider =CollisionShape3D.new()
	ship_collider.shape = box_collider
	return ship_collider
	
