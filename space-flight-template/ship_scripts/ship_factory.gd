@tool
extends Node3D
#Ship factory creates a single ship from a ship data resource node.
#Ship Collider is determined by the size of the model
#On scene load the ship factory is removed.
@export var ship_data : ShipData

var ship_model
var ship_model_instance : Node3D
var collision  : CollisionShape3D
@export var create_model : bool

func create_collider():
	if ship_model_instance != null and collision == null:
		collision = CollisionShape3D.new()
		
		var box_collider = BoxShape3D.new()
		box_collider.size = ship_model_instance.basis.get_scale()  * 100
		collision.shape = box_collider
		add_child(collision)
		collision.owner = get_tree().edited_scene_root
		
		
		

func spawn_model():
	#TODO Make this into a class
	if create_model:
		create_model = false
	
		ship_model = load("res://ship_models/" + ship_data.model_name)
		ship_model_instance = ship_model.instantiate()
		
		get_parent().add_child(ship_model_instance)
		ship_model_instance.position = get_parent().position
		ship_model_instance.owner = get_tree().edited_scene_root
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		spawn_model()
		create_collider()

	
	
