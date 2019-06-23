extends RigidBody2D

signal hit

func _on_Mob_body_entered(body):
	if body.name.begins_with("@PlayerBullet"):
		emit_signal("hit")
		queue_free()