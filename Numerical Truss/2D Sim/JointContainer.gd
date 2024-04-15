extends Node2D

func _ready():
	for child in get_children():
		for other_child in get_children():
			if other_child in child.single_connected_joints and not child in other_child.single_connected_joints:
				other_child.single_connected_joints.append(child)
			if other_child in child.double_connected_joints and not child in other_child.double_connected_joints:
				other_child.double_connected_joints.append(child)
	
	for child in get_children():
		child.apply_joint_connections()
