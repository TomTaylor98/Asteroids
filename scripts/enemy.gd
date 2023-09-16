extends CharacterBody2D

var Explosion = preload("res://effects/explosion.tscn")
var projectile = preload("res://weapons/projectile.tscn")
var SPEED = 50.0
var direction = Vector2.LEFT
var can_shoot = false
var target_position


func _ready():
	$cooldownTimer.start()

func explode():
	
	var explosion = Explosion.instantiate()
	explosion.position = self.position
	explosion.emitting = true
	get_parent().add_child(explosion)
	queue_free()

func _process(delta):
	
	position.x = wrap(position.x,-50,get_viewport_rect().size.x+50)
	if get_parent().get_node("player"):
		target_position = (position - get_parent().get_node("player").position).normalized()
	
	var collision = move_and_collide(SPEED*direction*delta)
	
	if collision:
		
		if PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())==4:
			collision.get_collider().queue_free()
			explode()
			
	if can_shoot:
		can_shoot = false
		var proj =  projectile.instantiate()
		proj.direction = -target_position
		proj.add_collision_exception_with(self)
		proj.position = position
		
		get_parent().add_child(proj)
		$cooldownTimer.start()
	

func set_direction(direction):
	self.direction = direction
	
func _on_cooldown_timer_timeout():
	can_shoot = true
