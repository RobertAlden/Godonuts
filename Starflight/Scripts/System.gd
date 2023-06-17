extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var asteroid = preload("res://Scenes/Asteroid.tscn")
var star = preload("res://Scenes/Star.tscn")

var base_scale = 1
var base_draw_size = 30
var node_draw_size = base_scale * base_draw_size
var prev_draw_size = base_scale * base_draw_size
var draw_points = 20
var node_color = Color(255,255,255)
var connections = []
var active = false
var line_width = .5

var num_of_bodies = 15
var body_rot_speed = 0.01
signal selected(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.shape.set_radius(node_draw_size)
	var s = star.instance()
	$Objects.add_child(s)
	for b in num_of_bodies:
		var a = asteroid.instance()
		$Objects/Bodies.add_child(a)
		a.position = Vector2.RIGHT.rotated((TAU/num_of_bodies) * b)*rand_range(3,node_draw_size-2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	node_draw_size = base_scale * base_draw_size
	var draw_size_delta = prev_draw_size - node_draw_size
		
	update()
	if active:
		$Objects.visible = true
		for b in $Objects/Bodies.get_children():
			b.position = b.position.rotated(pow(node_draw_size-b.position.length(),1)*body_rot_speed*delta)
	else:
		$Objects.visible = false
func _draw():
	draw_arc(Vector2.ZERO,node_draw_size,0,2*PI,draw_points,node_color,line_width,true)
	for conn in connections:
		var conn_pos = to_local(conn.global_position)
		var dir1 = Vector2.ZERO.direction_to(conn_pos).angle()
		var line_start = Vector2.RIGHT.rotated(dir1)*node_draw_size
		var dist = Vector2.ZERO.distance_to(conn_pos)
		var line_end = Vector2.RIGHT.rotated(dir1)*(dist-node_draw_size)
		draw_line(line_start,line_end,node_color,line_width,true)
	prev_draw_size = node_draw_size


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("selected", self)
