extends Area3D

@export_group("Parent components")
@export var parent : Node3D
@export var collision : CollisionShape3D
@export var sfx: AudioStream

@export_group("Collectable values")
@export var score_value : int = 1
@export var life_value : float = 0.0

func _on_body_entered(body):
	if body.is_in_group("Players"):
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		player.set_stream(sfx)
		add_child(player)
		player.play()
		
		if score_value > 0:
			body.call("add_score", score_value)
		if life_value > 0:
			body.call("add_life", life_value)
			
		collision.disabled = true
		parent.visible = false
		await get_tree().create_timer(1.0).timeout
		parent.queue_free()
