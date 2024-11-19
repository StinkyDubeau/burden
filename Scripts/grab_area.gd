extends Area3D

@onready var parent = get_node("../")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not parent == null:
		global_transform.origin = parent.get_point_transform(131)
