extends Resource
class_name ShipData

#Use Ship Data to determine ship data health system resource behavior attributes along with the type of model.

#Some notes of models, modular ships and components are not supported for this right now.

#MODEL DATA
@export var model_name : String
@export var ship_name : String
#SHIP BEHAVIOR ATTRIUBUTES -> max linear speed, thrust etc.

@export var mass : float
@export var has_max_speed : bool
@export var thrust_forward : float
@export var thrust_reverse : float
@export var thrust_strafe : float
@export var thrust_vertical : float
@export var max_speed : float
@export var max_angular_speed : float


	
	
	
	
	
