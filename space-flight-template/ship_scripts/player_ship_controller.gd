extends RigidBody3D
class_name PlayerShipController
@export var data : ShipData
@export var thrust : Thruster
@export var maneuver : ManeuveringThrust
var thrust_direction : Vector3
var radial_thrust_direction : Vector3
var inputVector : Vector3
var inputRadialVector : Vector3

func _ready() -> void:
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0

func flight_assist(state :  PhysicsDirectBodyState3D):
	var velocity = state.linear_velocity
	var speed = velocity.length()/data.max_speed
	print(velocity.length())
	var damped_velocity = velocity.normalized() * speed * data.max_speed
	thrust.add_thrust(self,-damped_velocity)

func apply_thrust():
	thrust_direction = inputVector
	thrust_direction.x *= data.thrust_strafe
	thrust_direction.y *= data.thrust_vertical

	if inputVector.z >= 0.0:
		thrust_direction.z *= data.thrust_forward
	elif inputVector.z < 0.0:
		thrust_direction.z *= data.thrust_reverse
	thrust.add_thrust(self,thrust_direction)
func input_thrust():
	inputVector.z = Input.get_axis("throttle_down","throttle_up")
	inputVector.x = Input.get_axis("strafe_left","strafe_right")
	inputVector.y = Input.get_axis("lower","raise")
func input_radial_thrust():
	pass
func _process(_delta: float) -> void:
	input_thrust()
func _physics_process(_delta: float) -> void:
	apply_thrust()
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	flight_assist(state)
