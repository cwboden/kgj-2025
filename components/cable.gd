extends StaticBody2D

func _ready() -> void:
	position = Globals.snap_to_center(position)
