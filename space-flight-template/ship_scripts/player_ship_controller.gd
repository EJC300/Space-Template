extends RigidBody3D
class_name PlayerShipController
@export var data : ShipData
@export var thrust : Thruster
@export var maneuver : ManeuveringThrust
var thrust_direction : Vector3
var radial_thrust_direction : Vector3
var inputVector : Vector3
var inputRadialVector : Vector3
var previous_angular_velocity : Vector3
var angular_velocity_error : Vector3

func _ready() -> void:
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp = 0.0

func get_mouse_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var center_screen = Vector3(get_viewport().get_visible_rect().size.x,get_viewport().get_visible_rect().size.y,100.0) * 0.5
	var world_mouse_pos = Vector3(mouse_pos.x,mouse_pos.y,0.0) - center_screen
	world_mouse_pos.z = 1000
	world_mouse_pos.x /= get_viewport().get_visible_rect().size.x
	world_mouse_pos.y /= get_viewport().get_visible_rect().size.y
	world_mouse_pos= global_transform.translated(world_mouse_pos).origin
	return  world_mouse_pos
	

func flight_assist(state :  PhysicsDirectBodyState3D):
	var velocity = state.linear_velocity
	var speed = velocity.length()/data.max_speed
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
	inputRadialVector.z = Input.get_axis("roll_left","roll_right") * data.thrust_roll
	radial_thrust_direction = inputRadialVector
	radial_thrust_direction.x = (get_mouse_position()).y
	radial_thrust_direction.y = (get_mouse_position()).x
func apply_radial_thrust():

	


	angular_velocity_error =  radial_thrust_direction - previous_angular_velocity
	self.apply_torque(angular_velocity_error * 0.5)
	previous_angular_velocity = self.angular_velocity
	
	
func _process(_delta: float) -> void:
	input_thrust()
func _physics_process(_delta: float) -> void:
	apply_thrust()
	apply_radial_thrust()
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	flight_assist(state)
