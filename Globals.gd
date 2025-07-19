extends Node

var ANIMATION_SPEED = 8

var TILE_SIZE = 64

func snap_to_center(position: Vector2):
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
	return position
