@tool
extends Node3D
#Ship factory creates a single ship from a ship data resource node.
#Ship Collider is determined by the size of the model
#On scene load the ship factory is removed.
@export var ship_data : ShipData
@export var create_model : bool
@export var delete_model : bool
var collision : CollisionShape3D

var model : Node3D
func spawn_model():
	model = ShipModelController.create_ship_model(ship_data.model_name)
	get_parent().add_child(model)
	model.owner = get_tree().edited_scene_root


func spawn_collider():
	collision =  ShipModelController.create_ship_collider()
	collision.name = "Collision" + ship_data.model_name
	get_parent().add_child(collision)
	collision.owner = get_tree().edited_scene_root
	
func _ready() -> void:
	if !Engine.is_editor_hint():
		queue_free()

func _process(_delta: float) -> void:
	if !collision and !model and Engine.is_editor_hint() and create_model:
		create_model = false
		spawn_collider()
		spawn_model()
		
	elif delete_model and collision and Engine.is_editor_hint():
		delete_model = false
		collision.queue_free()
		model.queue_free()
			
		
		
	
	
		

	
	
