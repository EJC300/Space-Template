@tool
extends Node3D
#Ship factory creates a single ship from a ship data resource node.
#Ship Collider is determined by the size of the model
#On scene load the ship factory is removed.
@export var ship_data : ShipData

var ship_model : ShipModel
var ship_model_instance : ShipModel
var collision_instance  : CollisionShape3D
var ship_mesh_instance : Node3D
@export var create_model : bool
@export var delete_model : bool

func spawn_collider():
	ship_model.create_ship_collider()
	if collision_instance != null:
		get_parent().add_child(ship_mesh_instance)
		collision_instance = get_tree().edited_scene_root
		

func spawn_model():
	ship_model_instance=ship_model.new()
	if ship_model_instance != null:
		get_parent().add_child(ship_mesh_instance)
		ship_model_instance.owner = get_tree().edited_scene_root
		ship_mesh_instance.create_ship_model()
	
	if ship_mesh_instance != null:
		get_parent().add_child(ship_mesh_instance)
		ship_mesh_instance.owner = get_tree().edited_scene_root
		
func delete():
	if delete_model:
		ship_mesh_instance.queue_free()
		collision_instance.queue_free()
func _ready() -> void:
	queue_free()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and create_model:
		spawn_model()
		spawn_collider()
		delete()
	
	
		

	
	
