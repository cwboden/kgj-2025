class_name Outlet
extends Node

var plugging_in = false
var has_connection = false

func _ready():
	Events.drop_plug.connect(_on_drop_plug)
	Events.plug_in.connect(_on_plug_in)


func _on_interact():
	if not has_connection:
		print("trying to plug in")
		plugging_in = true
		Events.try_plug_in.emit()


func _on_drop_plug():
	plugging_in = false
	

func _on_plug_in():
	if plugging_in:
		has_connection = true
		plugging_in = false
