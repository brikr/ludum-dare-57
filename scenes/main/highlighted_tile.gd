extends Node2D

@export var size := Vector2.ONE * 14.0
@export var color := Color(1.0, 1.0, 0.0, 0.5)


func _draw():
	draw_rect(Rect2(-size / 2.0, size), color)
