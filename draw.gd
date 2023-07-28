extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var points = PackedVector2Array()
var size = 50.0

func v2(x,y):
	return Vector2()
	

func _ready():
	
	points.append(v2(0,-size))
	points.append(v2(-size/2,size/2))
	points.append(v2(size/2,size/2))
	points.append(v2(0,-size))

func _draw():
	draw_polyline(points,Color.WHITE,2.0)
	queue_redraw()
