extends Node3D
class_name ManeuveringThrust
#connected to ship_controller - ship controller is controlled with player or AI
signal add_axis_torque(body:RigidBody3D,force : Vector3)
