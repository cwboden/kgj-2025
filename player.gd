class_name Player
extends Area2D

@onready var cable_scene = preload("res://components/cable.tscn")
@onready var projectile_scene = preload("res://components/projectile.tscn")

@onready var ray = $RayCast_move
@onready var label = $InteractionLabel

@export var can_jump = false
@export var can_dash = false
@export var can_shoot = false
@export var direction = Vector2.DOWN

var can_grab_plug = false;
var can_plug_in = false;

var is_moving = false
var is_carrying = false
var is_plugging_in = false

var INPUTS = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _ready():
	position = Globals.snap_to_center(position)

	Events.set_ability.connect(_on_set_ability)


func _input(event: InputEvent) -> void:
	if is_moving:
		return
	if event.is_action_pressed("ui_accept"):
		interact()
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			direction = INPUTS[dir]
			try_move(dir)
			_check_in_front()


func _process(_delta: float) -> void:
	if can_grab_plug or can_plug_in:
		label.show()
	else:
		label.hide()


func _check_in_front():
	ray.position = Vector2(0, 0)
	ray.force_raycast_update()

	var collisions = []
	while ray.is_colliding():
		var obj = ray.get_collider()
		collisions.push_back(obj)
		
		print("Ahead: " + obj.name)

		ray.add_exception(obj)
		ray.force_raycast_update()


func interact():
	if can_grab_plug:
		print("grabbing plug")
		can_grab_plug = false;
		_on_grab_plug()
	elif can_plug_in:
		print("trying to plug in")
		can_plug_in = false;
		_on_try_plug_in()
	elif can_shoot:
		_shoot()
	else:
		print("dropping plug")
		_on_drop_plug()


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
			Events.plug_in.emit()
			is_carrying = false


func _lay_cable(drop_position):
	var cable = cable_scene.instantiate()
	cable.position = drop_position
	owner.add_child(cable)


func _shoot():
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	projectile.direction = direction
	owner.add_child(projectile)


func _on_grab_plug():
	is_carrying = true


func _on_drop_plug():
	is_plugging_in = false
	is_carrying = false


func _on_try_plug_in():
	if is_carrying:
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
