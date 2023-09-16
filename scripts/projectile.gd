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
	
	if position.x>wrapf(position.x,0,get_viewport_rect().size.x)or position.x<wrapf(position.x,0,get_viewport_rect().size.x):
		queue_free()
	if position.y>wrapf(position.y,0,get_viewport_rect().size.y)or position.y<wrapf(position.y,0,get_viewport_rect().size.y):
		queue_free()
	var collision = move_and_collide(direction*speed*delta)
	
	queue_redraw()
	
	
	
	
func _draw():
	pass
	


func _on_area_2d_body_entered(body):
	queue_free()
