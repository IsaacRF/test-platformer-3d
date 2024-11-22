extends Area3D

@export var hit_points : float = 1.0
@export var knockback_force : float = 10.0

func _on_body_entered(body):
	if body.is_in_group("Players"):
		# The player entered the hazard zone.
		body.call("damage", hit_points, knockback_force)
