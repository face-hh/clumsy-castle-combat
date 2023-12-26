extends Node3D

var damage
@export var target: CharacterBody3D

func _process(delta):
	if is_instance_valid(target):
		position = position.move_toward(target.position, delta * 20)

func _on_area_3d_body_entered(body):
	if "enemy" in body.name:
		body.take_damage(damage)
		self.queue_free()
