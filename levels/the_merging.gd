extends Node2D
@onready var Targets=$targets
@onready var Barracade=$Barracade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Targets.get_child_count()==0:
		Barracade.visible=false
		Barracade.collision_enabled=false
