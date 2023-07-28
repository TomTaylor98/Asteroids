extends Sprite2D



var points = PackedVector2Array()
#var po = PackedVector2Array(Vector2(rectpos))
var time = Time.get_ticks_msec()

func _ready():
	
	#points.append_array([v2(rectsize.x/2,0),v2(rectpos.x,rectsize.y),v2(rectsize.x,rectsize.y)])
	points.append_array([v2(0,0),v2(200,200)])
	points.append_array([
					get_viewport_rect().get_center(),
					get_global_mouse_position()
					])
	#print(get_rect().size)
	#print(rectsize)
	#print(end)

func v2(x,y):
	return Vector2(x,y)
	

func _draw():
	pass
	#draw_circle(v2(0,0),100.0,Color.RED)
	#draw_polyline(points,Color.RED,5.0,true)


func _physics_process(delta):
	pass
	#scale = cos(Time.get_ticks_msec()-time)
	


