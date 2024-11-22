extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Players"):
		# The player entered the hazard zone.
		body.call("game_over")
