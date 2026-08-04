extends RigidBody3D
class_name Ship
@export var ship_data : ShipData
@onready var ship_controller_compoent  = $ShipComponent
@export var input_component : BaseInputComponent
func _physics_process(_delta: float) -> void:
	input_component._process_input()
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
	ship_controller_compoent.update_ship_physics_state(input_component.get_thrust_axis(),input_component.get_radial_thrust_axis(),state,ship_data)
	
