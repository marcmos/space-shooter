extends RigidBody2D

signal hit

func _on_Mob_body_entered(body):
	if body.get_collision_layer_bit(1):
		emit_signal("hit")
		queue_free()