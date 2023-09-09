extends GPUParticles2D

func _physics_process(delta):
	if !emitting:
		queue_free()
	
