extends Area3D

@export_file("*.tscn") var next_level
@onready var collision_shape_3d = $CollisionShape3D
@onready var sfx = $Sfx

func _on_body_entered(body):
	if body.is_in_group("Players"):
		# The player entered the goal zone
		collision_shape_3d.disabled = true
		visible = false
		
		sfx.play()
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(next_level)
