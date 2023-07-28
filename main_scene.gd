extends Node2D

const SPEED_MIN = 20.0
const SPEED_MAX = 40.0
const ASTEROID_COUNT = 5
var asteroid_spawn_count 
var offset = 40.0
var score = 0

var asteroid_asset = load("res://Asteroid.tscn")
var Player = preload("res://player.tscn")
var explosionsound = preload("res://sounds/shipExplosion.wav")




@onready var center = get_viewport_rect().get_center()
@onready var screensize = get_viewport_rect().size

@onready var mainMenu = $Control/MainMenu
@onready var gameoverMenu = $Control/GameOverMenu
@onready var livescounter = $Control/livescounter

@onready var player = Player.instantiate()

func _ready():
	
	player.position = center
	add_child(player)
	livescounter.text = str(player.lives)
	

func spawnAsteroids(num):
	for i in num:
			var asteroid = asteroid_asset.instantiate()
			asteroid.setSize(randi_range(1,3))
			
			if randi_range(0,1):
				asteroid.setPosition(wrapf(randf_range(screensize.x,screensize.x + 2*offset),-offset,screensize.x+offset),center.y+ randf_range(-screensize.y/2,screensize.y/2))
			else:
				asteroid.setPosition(center.x + randf_range(-screensize.x/2,screensize.x/2),wrapf(randf_range(screensize.y,screensize.y + 2*offset),-offset,screensize.y+offset))

			asteroid.setDirection((center-asteroid.position).normalized().rotated(randf_range(-PI/3,PI/3)))
			add_child(asteroid)
			mainMenu.visible = false


func swithcActivity(c):
	c.set_physics_process(!c.is_physics_processing())
	
func gameOver():	
	gameoverMenu.visible = true
	

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_children().map(swithcActivity)
			gameoverMenu.visible = !gameoverMenu.visible
			

func _on_exit_pressed():
	get_children().map(func(x): x.queue_free())
	get_tree().quit() 

func _on_restart_pressed():
	get_children().map(swithcActivity)
	get_tree().reload_current_scene()
	

func _on_start_pressed():
	spawnAsteroids(ASTEROID_COUNT)
	mainMenu.visible = false

func asteroidexplosionSound():
	if gameoverMenu!=null and !gameoverMenu.visible:
		if !$explosionSoundAsteroid.playing:
			$explosionSoundAsteroid.play()
			

func shipexplosionSound():
	if $explosionSoundShip != null:
		$explosionSoundShip.play()
		

func _on_child_exiting_tree(node):
	var score_multiplier = 10
	if gameoverMenu !=null:
		if node is CharacterBody2D and !gameoverMenu.visible:
			if node.get_collision_layer()==2:
				score = int($Control/Score.text)
				$Control/Score.text = str(score+node.getSize()*score_multiplier)
				asteroid_spawn_count = score/100

func _on_timer_timeout():
	if asteroid_spawn_count:
		spawnAsteroids(asteroid_spawn_count) # Replace with function body.

func _update_lives_counter():
	livescounter.text = str(player.lives)
