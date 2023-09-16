
extends CharacterBody2D

var rotationSpeed = PI/30
var ACCELERATION = 500.0
var ACCELERATION_VECTOR = Vector2.UP*ACCELERATION/2
var size = 20.0
var offset = 5.0
var Explosion = preload("res://effects/explosion.tscn")
var Projectile = preload("res://weapons/projectile.tscn")

var shootsound = preload("res://sounds/asteroidExplosion.wav")

var lives = 3
var s_param = float()
var canTakeDamage = true
var canShoot = true
@onready var viewport = get_viewport_rect()

@onready var ship_points = PackedVector2Array([
								v2(0,-size),
								v2(-size/2,size/2),
								v2(size/2,size/2),
								v2(0,-size)])
@onready var Projectile_points = PackedVector2Array([])

signal takingDamage

func _ready():
	
	connect("takingDamage",Callable(get_parent(),"_update_lives_counter"))
	connect("tree_exited",Callable(get_parent(),"shipexplosionSound"))
	$CollisionShape2D.get_shape().set_points(ship_points)
	position = get_viewport_rect().get_center()
	
	
	
func v2(x,y):
	return Vector2(x, y)

func explode():
	
	get_parent().call("gameOver")
	var explosion = Explosion.instantiate()
	explosion.position = position
	explosion.emitting = true
	explosion.lifetime = 8.0
	explosion.process_material.damping_min = 1.0
	explosion.amount = 20
	get_parent().add_child(explosion)
	queue_free()

func accelerate(rotation,time):
	velocity += ACCELERATION_VECTOR.rotated(rotation)*pow(time,2)


func shoot():
	$shoot.play()
	var projectile = Projectile.instantiate()
	projectile.add_collision_exception_with(self)
	projectile.position = position + Vector2.UP.rotated(rotation)*10
	projectile.direction = Vector2.UP.rotated(rotation)
	get_parent().add_child(projectile)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_C and canShoot:
			shoot()
			canShoot = false
			$cooldownTimer.start()
		
func _physics_process(delta):
	queue_redraw()
	rotate(Input.get_axis(&"turn_left", &"turn_right")*rotationSpeed)
	
	if Input.is_action_pressed("boost"):
		accelerate(rotation,delta)
		
	position.x = wrapf(position.x,-offset,viewport.size.x + offset)
	position.y = wrapf(position.y,-offset,viewport.size.y+offset)
	
	var collision = move_and_collide(velocity)
	
	if !canTakeDamage:
		s_param+=0.03 
		material.set_shader_parameter("hit_opacity",wrapf(s_param,0.0,1.0))
	
	if collision and canTakeDamage:
		if !lives:
			explode()
		else:
			lives-=1
			emit_signal("takingDamage")
			velocity = -velocity.normalized()*100.0*delta
			set_collision_layer_value(1,false)
			set_collision_mask_value(2,false)
			
		canTakeDamage = false
		
		$damageTimer.start()
		
	

func _draw():
	draw_polyline(ship_points,Color.WHITE,2.0)
	

func _on_cooldown_timeout():
	$cooldownTimer.stop()
	canShoot = true 


func _on_damage_timer_timeout():
	s_param = 0.0
	set_collision_layer_value(1,true)
	set_collision_mask_value(2,true)
	material.set_shader_parameter("hit_opacity",0)
	canTakeDamage = true # Replace with function body.
