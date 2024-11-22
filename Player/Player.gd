extends CharacterBody3D

var move_speed : float = 6.0
var acceleration : float = 0.3
var decceleration : float = 0.4
var rotation_speed : float = 0.1
var jump_force : float = 8.0
var gravity : float = 20.0

var facing_angle : float

@onready var model = $Model
@onready var death_sfx = $DeathSFX
@onready var animation_player = $AnimationPlayer
@onready var camera_follow = $CameraFollow
@onready var camera = $Camera

func _physics_process(delta):	
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump_force
	
	if input.length() > 0:
		velocity.x = move_toward(velocity.x, dir.x * move_speed, acceleration)
		velocity.z = move_toward(velocity.z, dir.z * move_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.z = move_toward(velocity.z, 0, acceleration)
	
	move_and_slide()
	
	if input.length() > 0 && is_on_floor():
		facing_angle = Vector2(input.y, input.x).angle()
		model.rotation.y = lerp_angle(model.rotation.y, facing_angle, rotation_speed)
		
func game_over():
	animation_player.play("Death")
	death_sfx.play()
	camera_follow.update_position = false
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
