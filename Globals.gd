class_name Globals
extends Node

static var ANIMATION_SPEED = 8
static var TILE_SIZE = 64

static func snap_to_center(position: Vector2):
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
	return position
