extends StaticBody2D

var is_connected := false

func _ready() -> void:
	Events.drop_plug.connect(_on_drop_plug)
	Events.plug_in.connect(_on_plug_in)


func _on_drop_plug():
	if not is_connected:
		self.queue_free()


func _on_plug_in():
	is_connected = true
