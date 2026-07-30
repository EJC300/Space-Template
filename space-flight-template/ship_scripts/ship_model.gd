@tool
extends Node3D
#Ship Model spawns and holds the 3D mesh and scales the a box collider that is also attached to spaceship
#Model node

class_name ShipModel
var ship_mesh 
var ship_collider : CollisionShape3D
var ship_model_instance : Node3D
var ship_instance : Node3D
func create_ship_model(mesh_name : String):
	var mesh_path = "res://ship_models/" + mesh_name
	ship_mesh = load(mesh_path)
	ship_instance = ship_mesh.instantiate()
	
func create_ship_collider():
	ship_collider = CollisionShape3D.new()
	var box_collider = BoxShape3D.new()
	box_collider.size = ship_model_instance.basis.get_scale()  * 2	
	ship_collider.shape = box_collider
	
