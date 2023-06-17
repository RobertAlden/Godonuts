extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var points = []
var rot_speed = 1
var asteroid_color = Color(255,255,255)

# Called when the node enters the scene tree for the first time.
func _ready():
	var num_of_points = 20
	var ang = (2*PI) / num_of_points
	for i in num_of_points:
		var new_point = Vector2.RIGHT.rotated(ang*i) * rand_range(0.2,0.3)
		points.append(new_point)
	points.append(points[0])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	
func _draw():
	draw_polyline(points,asteroid_color,1,true)
		
