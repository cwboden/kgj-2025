class_name Plug
extends StaticBody2D

@onready var interactable = $Interaction

# TODO: update Sprite during state changes
@onready var sprite = $Sprite2D

enum PlugType {
	JUMP,
	DASH,
	SHOOT,
	CUSTOM, # uses the `on_connected` signal manually
}

@export var type: PlugType

signal on_connected()

var has_connection = false
var is_grabbed = false

func _ready():
	interactable.interact = _on_interact
	on_connected.connect(_on_connected)
	
	Events.plug_in.connect(_on_plug_in)
	Events.drop_plug.connect(_on_drop_plug)


func _on_interact():
	if not has_connection and not is_grabbed:
		print("grabbing plug")
		is_grabbed = true
		Events.grab_plug.emit()


func _on_plug_in():
	if is_grabbed:
		print("outlet connected")
		has_connection = true
		on_connected.emit()
		

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
