extends RigidBody3D

@export var static_joint = false

@export var single_connected_joints: Array[RigidBody3D]
@export var double_connected_joints: Array[RigidBody3D]

var joints = {} # joints[RigidBody2D] = [L, A, Label]
var forces = {} # forces[RigidBody2D] = F

func _ready():
	if static_joint:
		gravity_scale = 0

func apply_joint_connections():
	for joint in double_connected_joints:
		joints[joint] = [position.distance_to(joint.position), 51, new_force_label()]
		forces[joint] = Vector3.ZERO
	for joint in single_connected_joints:
		joints[joint] = [position.distance_to(joint.position), 30, new_force_label()]
		forces[joint] = Vector3.ZERO

func new_force_label():
	var label = force_label.instantiate()
	add_child(label)
	return label

func _process(delta):
	constant_force = Vector2.ZERO
	
	if not static_joint:
		for joint in joints:
			var L = joints[joint][0]
			var A = joints[joint][1]
			var e = (joint.position - position).normalized() * (position.distance_to(joint.position) - L)
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
		joints[joint][2].text = str(int(forces[joint].length()))
		draw_line(Vector2.ZERO, label_position, Color(0.5,0,0), 3)
