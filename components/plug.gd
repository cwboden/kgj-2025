class_name Plug
extends Node

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

enum Setting {
	ABILITY,
	FRAME,
}

var SETTINGS = {
	PlugType.JUMP: {
		Setting.ABILITY: Events.Ability.JUMP,
		Setting.FRAME: 1,
	},
	PlugType.DASH: {
		Setting.ABILITY: Events.Ability.DASH,
		Setting.FRAME: 2,
	},
	PlugType.SHOOT: {
		Setting.ABILITY: Events.Ability.SHOOT,
		Setting.FRAME: 3,
	},
	PlugType.CUSTOM: {
		Setting.FRAME: 4,
	}
}

func _ready():
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
	var ability = SETTINGS[type][Setting.ABILITY]
	Events.set_ability.emit(ability, true)
