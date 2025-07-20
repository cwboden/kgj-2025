class_name Projectile
extends Node2D

var SPEED = 1024
var direction: Vector2

func _process(delta: float) -> void:
	position.x += direction.x * delta * SPEED
	position.y += direction.y * delta * SPEED


func _on_area_entered(target: Target) -> void:
	target.on_hit.emit()
	queue_free()
