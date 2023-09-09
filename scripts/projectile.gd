extends StaticBody2D


var speed = 800.0
var direction = Vector2(0,0)
var radius = 5.0
var pos

func _ready():
	pos = position
	$CollisionShape2D.get_shape().set_radius(radius)
	constant_linear_velocity = direction*speed

func _physics_process(delta):
	position += delta*direction*speed
	if position.x>wrapf(position.x,0,get_viewport_rect().size.x)or position.x<wrapf(position.x,0,get_viewport_rect().size.x):
		queue_free()
	if position.y>wrapf(position.y,0,get_viewport_rect().size.y)or position.y<wrapf(position.y,0,get_viewport_rect().size.y):
		queue_free()
	queue_redraw()
	
func _draw():
	pass
	
