extends Node2D

@onready var targets = $targets
@onready var barrier = $"Overworld Items"

func _process(_delta: float) -> void:
	if targets.get_child_count() == 0:
		barrier.collision_enabled = false
		barrier.visible = false
