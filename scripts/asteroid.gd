extends CharacterBody2D

const MAX_SIZE_1 = 30
const MIN_SIZE_1 = 10

const MAX_SIZE_2 = 40
const MIN_SIZE_2 = 50

const MAX_SIZE_3 = 70
const MIN_SIZE_3 = 50

const MIN_SPEED = 1.0
const MAX_SPEED = 2.0

var points = PackedVector2Array()
var size
var SIZE_TYPE = 1
var numberOfPoints
var rotationSpeed
var direction = Vector2()

var isAsteroidActive = true

var Explosion = preload("res://effects/explosion.tscn")

func setSize(type):
	SIZE_TYPE = type

func getSize():
	return SIZE_TYPE

func setPosition(x,y):
	position = Vector2(x,y)
func setDirection(v):
	direction = v
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tree_exited",Callable(get_parent(),"asteroidexplosionSound"))
	rotationSpeed = randf_range(0.1,1.0)
	points = calculate_points()
	$CollisionPolygon2D.polygon = points
	#$LightOccluder2D.polygon = points
	$LightOccluder2D.occluder.polygon = points
	#var direction = Vector2.UP.rotated(randf_range(0.0,2*PI))
	#constant_linear_velocity = direction*randf_range(MIN_SPEED,MAX_SPEED)
	velocity = direction*randf_range(MIN_SPEED,MAX_SPEED)
	
func calculate_points():
	var points = PackedVector2Array()
	numberOfPoints = 5 + randi() % 10
	
	var point = Vector2()
	var min 
	var max  
	
	if SIZE_TYPE==1:
		min = MIN_SIZE_1 
		max = MAX_SIZE_1
	if SIZE_TYPE==2:
		min = MIN_SIZE_2
		max = MAX_SIZE_2
	if SIZE_TYPE==3:
		min = MIN_SIZE_3
		max = MAX_SIZE_3
		
	for i in range(numberOfPoints):
		size = min+ randi() %max
		point.x = size*cos(i*2*PI/numberOfPoints)
		point.y = size*sin(i*2*PI/numberOfPoints)
		points.append(point)
	points.append(points[0])
	return points
	

func splitAsteroid():
	
	var explosion = Explosion.instantiate()
	explosion.position = position
	explosion.emitting = true
	get_parent().add_child(explosion)
	if SIZE_TYPE==1:
		queue_free()
		return
	var as1 = get_parent().asteroid_asset.instantiate()
	var as2 = get_parent().asteroid_asset.instantiate()
	as1.SIZE_TYPE = SIZE_TYPE-1
	as2.SIZE_TYPE = SIZE_TYPE-1
	as1.position = position
	as2.position = position
	as1.setDirection(Vector2(randf_range(0,PI),randf_range(0,PI)))
	as2.setDirection(Vector2(randf_range(0,-PI),randf_range(0,PI)))
	get_parent().add_child(as1)
	get_parent().add_child(as2)
	queue_free()

func _process(delta):
	queue_redraw()

func _physics_process(delta):
		
	rotate(rotationSpeed*delta)
	var collision = move_and_collide(velocity)
	if collision:
		
		if PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())==4:
			
			collision.get_collider().queue_free()
			splitAsteroid()
			
	position.x = wrapf(position.x,-100.0,get_viewport_rect().size.x + 100.0)
	position.y = wrapf(position.y,-100.0,get_viewport_rect().size.y + 100.0)
	
func _draw():
	draw_polyline(points,Color.WHITE)


