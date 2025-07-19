extends StaticBody2D

@onready var connectable = $Connectable
@onready var interactable = $Interaction

# TODO: update Sprite during state changes
@onready var sprite = $Sprite2D

var plugging_in = false

func _ready():
	interactable.interact = _on_interact
	
	Events.drop_plug.connect(_on_drop_plug)
	Events.plug_in.connect(_on_plug_in)


func _on_interact():
	if not connectable.is_connected:
		plugging_in = true
		Events.try_plug_in.emit()


func _on_drop_plug():
	plugging_in = false
	

func _on_plug_in():
	if plugging_in:
		connectable.is_connected = true
		plugging_in = false
