extends StaticBody2D

@onready var interactable = $Interaction
@onready var sprite = $Sprite2D

func _ready():
	
	interactable.interact = _on_interact

func _on_interact():
	Events.player.emit(EventTypes.PlayerEvent.GRAB_PLUG)
	
