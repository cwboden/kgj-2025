extends Node2D

func _ready():
	Spawning.spawn.connect(_on_spawn)


func _on_spawn(scene: PackedScene, spawn_position: Vector2):
	var entity = scene.instantiate()
	add_child(entity)
	entity.position = spawn_position
