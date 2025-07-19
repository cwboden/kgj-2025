extends Area2D

var is_moving = false

var is_carrying = false
@export var cable_scene = PackedScene

var INPUTS = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@onready var ray = $RayCast2d


func _ready():
	position = Globals.snap_to_center(position)

	Events.player.connect(_handle_event)

func _unhandled_input(event):
	if is_moving:
		return
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			try_move(dir)
			


func try_move(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE
	var old_position = position
	ray.target_position = delta
	ray.force_raycast_update()
	if !ray.is_colliding():
		_move(dir)
		if is_carrying:
			_drop_cable(old_position)
		
		
func _move(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE
	var tween = get_tree().create_tween()
	tween.tween_property(
			self, 
			"position", 
			position + delta, 
			1.0/Globals.ANIMATION_SPEED
		).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	$AnimationPlayer.play(dir)
	await tween.finished
	is_moving = false


func _drop_cable(drop_position):
	print("dropping cable...")
	Spawning.spawn.emit(cable_scene, drop_position)


func _handle_event(type: EventTypes.PlayerEvent):
	print("picked up cable!")
	is_carrying = true
