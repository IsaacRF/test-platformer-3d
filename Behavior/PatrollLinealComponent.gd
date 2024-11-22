extends Node

@export var target : CharacterBody3D
@export var move_speed : float = 10.0
@export var move_dir : Vector3

var start_pos : Vector3
var target_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = target.global_position
	target_pos = start_pos + move_dir


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target.global_position = target.global_position.move_toward(target_pos, move_speed * delta)
	
	if target.global_position == target_pos:
		if target.global_position == start_pos:
			target_pos = start_pos + move_dir
		else:
			target_pos = start_pos
