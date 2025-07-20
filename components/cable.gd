extends StaticBody2D

@onready var sparks = $Sparks

var has_connection := false

func _ready() -> void:
	Events.drop_plug.connect(_on_drop_plug)
	Events.plug_in.connect(_on_plug_in)


func _on_drop_plug():
	if not has_connection:
		self.queue_free()


func _on_plug_in():
	has_connection = true
	

func _process(_delta: float) -> void:
	if has_connection:
		sparks.show()
	else:
		sparks.hide()
		
