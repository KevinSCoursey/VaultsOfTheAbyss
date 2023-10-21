class_name Climb_Zone extends Area2D

func _on_body_entered(body) -> void:
	if body is Player:
		# If a body enters the climbing region and it is a player, increment the number
		# of climbing areas by 1. If the count is zero, then they won't be able to climb
		body.climbing_region_count += 1

func _on_body_exited(body) -> void:
	if body is Player:
		# If a body leaves the climbing region and it is a player, decrement the number
		# of climbing areas by 1. If the count is zero, then they won't be able to climb
		body.climbing_region_count -= 1
