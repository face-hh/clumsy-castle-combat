class_name Bullet

extends Node3D

var damage: int
var target: CharacterBody3D
var side: String

func _process(delta: float) -> void:
	if is_instance_valid(target):
		position = position.move_toward(target.position, delta * 20)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if "enemy" in body.name and (body as Character).res.type != DataType.TYPES.SPELL and !(side in body.name):
		(body as Character).take_damage(damage)
		self.queue_free()
