extends CharacterBody3D

signal score_updated(score)
signal life_updated(life)

var move_speed : float = 6.0
var acceleration : float = 0.3
var decceleration : float = 0.4
var rotation_speed : float = 0.1
var jump_force : float = 8.0
var gravity : float = 20.0

var facing_angle : float

var is_dead : bool = false

var score : int
@export var max_life : int = 3
@export var life : float = max_life

@onready var model = $Model
@onready var death_sfx = $DeathSFX
@onready var jump_sfx = $JumpSFX
@onready var hurt_sfx = $HurtSFX
@onready var animation_player = $AnimationPlayer
@onready var camera_follow = $CameraFollow
@onready var collision_shape_3d = $CollisionShape3D
@onready var rng = RandomNumberGenerator.new()

func _physics_process(delta):	
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = Vector3(input.x, 0, input.y)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("jump") && is_on_floor():
		jump_sfx.play()
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
		
func damage(hit_points : float = 1.0, knockback_force : float = 10.0):
	life -= hit_points
	life_updated.emit(life)
	
	if life <= 0:
		game_over()
	else:
		hurt_sfx.pitch_scale = rng.randf_range(0.8, 1.2)
		hurt_sfx.play()
		#TODO: Hurt animation
		#var tween = get_tree().create_tween().set_loops(3)
		#tween.tween_property(model, "modulate", Color.RED, 0.1)
		#tween.tween_property(model, "modulate", Color.WHITE, 0.1)
		#Add back force
		var knockback_dir = Vector3(-sin(facing_angle), 0, -cos(facing_angle)).normalized()
		var knockback_velocity : Vector3 = knockback_dir * knockback_force
		velocity += knockback_velocity
		velocity.y = jump_force

func game_over():
	is_dead = true
	life = 0
	life_updated.emit(life)
	
	collision_shape_3d.set_deferred("disabled", true)
	animation_player.play("Death")
	death_sfx.play()
	camera_follow.update_position = false
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
