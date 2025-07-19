extends StaticBody2D

@onready var interactable = $Interaction
@onready var sprite = $Sprite2D

func _ready():
	position = Globals.snap_to_center(position)
	interactable.interact = _on_interact

func _on_interact():
	print("interacted: " + interactable.interaction_name)
