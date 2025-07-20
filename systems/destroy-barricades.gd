extends Node

@onready var targets = $Targets
@onready var barricade = $Barricade

func _process(_delta: float) -> void:
	if targets.get_child_count() == 0:
		barricade.collision_enabled = false
		barricade.visible = false
