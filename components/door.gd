extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

@export var plug: Plug
@export var is_open = false

func _ready() -> void:
	plug.on_connected.connect(_on_open)


func _process(_delta: float) -> void:
	collision.disabled = is_open
	sprite.visible = not is_open


func _on_open():
	is_open = true
