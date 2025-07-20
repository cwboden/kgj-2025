class_name Player
extends Area2D

@onready var cable_scene = preload("res://components/cable.tscn")
@onready var projectile_scene = preload("res://components/projectile.tscn")

@onready var ray = $RayCast_move

var INPUTS = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@export var can_jump = false
@export var can_dash = false
@export var can_shoot = false
@export var direction = Vector2.DOWN

var is_moving = false
var is_carrying = false
var is_plugging_in = false

func _ready():
	position = Globals.snap_to_center(position)

	Events.grab_plug.connect(_on_grab_plug)
	Events.drop_plug.connect(_on_drop_plug)
	Events.try_plug_in.connect(_on_try_plug_in)
	Events.set_ability.connect(_on_set_ability)


func _unhandled_input(event):
	if is_moving:
		return
	if event.is_action_pressed("ui_accept") and can_shoot:
		_shoot()
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			direction = INPUTS[dir]
			try_move(dir)


func try_move(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE
	var old_position = position
	
	# play animation, to show what walking into a wall would do
	$AnimationPlayer.play(dir)
	
	# reset RayCast
	ray.position = Vector2(0, 0)
	ray.target_position = delta
	ray.force_raycast_update()
	if !ray.is_colliding():
		_move(dir)
		_try_lay_cable(old_position)
	elif can_jump and not is_carrying:
		ray.position = delta
		ray.force_raycast_update()
		if !ray.is_colliding():
			_jump(dir)
	elif can_dash:
		var collision = ray.get_collider()
		if collision is Dashable:
			_dash(dir)
			_try_lay_cable(old_position)
			_try_lay_cable(old_position + delta)


func _move(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE
	var tween = get_tree().create_tween()
	tween.tween_property(
			self, 
			"position", 
			position + delta, 
			0.5/Globals.ANIMATION_SPEED
		).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	await tween.finished
	is_moving = false


func _jump(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE * 2
	var tween = get_tree().create_tween()
	tween.tween_property(
			self, 
			"position", 
			position + delta, 
			1.0/Globals.ANIMATION_SPEED
		).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	Sounds.jump.play()
	$AnimationPlayer.play("jump")
	await tween.finished
	is_moving = false


func _dash(dir):
	var delta = INPUTS[dir] * Globals.TILE_SIZE * 2
	var tween = get_tree().create_tween()
	tween.tween_property(
			self, 
			"position", 
			position + delta, 
			1.0/Globals.ANIMATION_SPEED
		).set_trans(Tween.TRANS_SINE)
	
	is_moving = true
	Sounds.dash.play()
	$AnimationPlayer.speed_scale = 2.0
	$AnimationPlayer.play(dir)
	await tween.finished
	$AnimationPlayer.speed_scale = 1.0
	is_moving = false
	

func _try_lay_cable(drop_position):
	if is_carrying:
		_lay_cable(drop_position)
		if is_plugging_in:
			print("plugging in!")
			Sounds.plug_in.play()
			Events.plug_in.emit()
			is_carrying = false


func _lay_cable(drop_position):
	var cable = cable_scene.instantiate()
	cable.position = drop_position
	owner.add_child(cable)
	Sounds.thud.play()


func _shoot():
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	projectile.direction = direction
	owner.add_child(projectile)


func _on_grab_plug():
	Sounds.pickup.play()
	is_carrying = true


func _on_drop_plug():
	is_plugging_in = false
	is_carrying = false


func _on_try_plug_in():
	if is_carrying:
		Sounds.pickup.play()
		is_plugging_in = true


func _on_set_ability(type: Events.Ability, is_active: bool):
	print("setting ability")
	match type:
		Events.Ability.JUMP:
			can_jump = is_active
		Events.Ability.DASH:
			can_dash = is_active
		Events.Ability.SHOOT:
			can_shoot = is_active
