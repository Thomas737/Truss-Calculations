extends RigidBody2D

const force_label = preload("res://2D Sim/force.tscn")

var weight_multiplier: float = 1
var original_mass: float

@export var static_joint = false
@export var variable_mass = false

@export var single_connected_joints: Array[RigidBody2D]
@export var double_connected_joints: Array[RigidBody2D]

var joints = {} # joints[RigidBody2D] = [L, A, Label]
var forces = {} # forces[RigidBody2D] = F

func _ready():
	if static_joint:
		gravity_scale = 0
	original_mass = mass

func apply_joint_connections():
	for joint in double_connected_joints:
		joints[joint] = [position.distance_to(joint.position), 51*pow(10, -3), new_force_label()]
		forces[joint] = Vector2.ZERO
	for joint in single_connected_joints:
		joints[joint] = [position.distance_to(joint.position), 30*pow(10, -3), new_force_label()]
		forces[joint] = Vector2.ZERO

func new_force_label():
	var label = force_label.instantiate()
	add_child(label)
	return label

func _input(event: InputEvent) -> void:
	if not variable_mass:
		return
	if event.is_action_pressed("increase_weight"):
		print("here")
		weight_multiplier += 1
	if event.is_action_pressed("decrease_weight"):
		weight_multiplier -= 1
	mass = original_mass * weight_multiplier

func _physics_process(delta: float) -> void:
	constant_force = Vector2.ZERO
	
	if not static_joint:
		for joint in joints:
			var L = joints[joint][0]/100
			var A = joints[joint][1]
			var e = (joint.position - position).normalized() * (position.distance_to(joint.position)/100 - L)
			var E = Global.elastic_modulus
			
			var F = E*A*e / L
			forces[joint] = F
			
			apply_central_force(F * delta)
	
	queue_redraw()

func _draw():
	for joint in joints:
		draw_line(Vector2.ZERO, (joint.position - position)/2, Color(0,0,0,0.3), 3)
		
		var label_position = (joint.position - position).normalized() * log(abs(forces[joint].length())) * sign(forces[joint].length()) * 3
		joints[joint][2].position = label_position
		joints[joint][2].text = str(int(forces[joint].length()/10))
		draw_line(Vector2.ZERO, label_position, Color(0.5,0,0), 3)
	if not static_joint:
		draw_line(Vector2.ZERO, Vector2.DOWN*mass*100, Color.GREEN, 2)
