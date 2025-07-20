extends Node2D

@export var next_level: PackedScene

func _on_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		get_tree().change_scene_to_packed(next_level)
