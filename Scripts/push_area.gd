extends Area3D

const push_strength = 10.0
@export var parent = Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not parent == null:
		global_transform.origin = parent.get_point_transform(0)
	
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			body.velocity += global_transform.origin.direction_to(body.global_transform.origin) * (push_strength * delta)
