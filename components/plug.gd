extends StaticBody2D

@onready var connectable = $Connectable
@onready var interactable = $Interaction

# TODO: update Sprite during state changes
@onready var sprite = $Sprite2D

enum PlugType {
	JUMP,
	DASH,
	SHOOT,
}

@export var type: PlugType

var is_grabbed = false

func _ready():
	interactable.interact = _on_interact
	connectable.on_connected.connect(_on_connected)
	
	Events.plug_in.connect(_on_plug_in)
	Events.drop_plug.connect(_on_drop_plug)


func _on_interact():
	if not connectable.is_connected:
		is_grabbed = true
		Events.grab_plug.emit()


func _on_plug_in():
	if is_grabbed:
		connectable.is_connected = true
		connectable.on_connected.emit()
		

func _on_drop_plug():
	is_grabbed = false
	
	
func _on_connected():
	match type:
		PlugType.JUMP:
			Events.set_ability.emit(Events.Ability.JUMP, true)
		PlugType.DASH:
			Events.set_ability.emit(Events.Ability.DASH, true)
		PlugType.SHOOT:
			Events.set_ability.emit(Events.Ability.SHOOT, true)
