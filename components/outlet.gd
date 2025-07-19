extends StaticBody2D

@onready var interactable = $Interaction
# TODO: update Sprite during state changes
@onready var sprite = $Sprite2D

var is_connected := false

func _ready():
	interactable.interact = _on_interact

func _on_interact():
	if not is_connected:
		Events.try_plug_in.emit()
		is_connected = true
	
