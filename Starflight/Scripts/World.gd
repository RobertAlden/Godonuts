extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = null

var default_cam_pos = Vector2.ZERO
var cam_max_zoom = 0.05
var cam_min_zoom = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	default_cam_pos = $Camera2D.position
	for c in $Galaxy/Systems.get_children():
		c.connect("selected", self, "_on_System_selected")


func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		if target != null:
			target.draw_points = 20
			target.active = false
		target = null
	if target != null:
		$Camera2D.position = lerp($Camera2D.position,to_local(target.global_position),2*delta)
		$Camera2D.zoom = lerp($Camera2D.zoom,Vector2.ONE*cam_max_zoom,2*delta)
	else:
		$Camera2D.zoom = lerp($Camera2D.zoom,Vector2.ONE*cam_min_zoom,2*delta)
		$Camera2D.position = lerp($Camera2D.position,default_cam_pos,2*delta)
	
		

func _on_System_selected(id):
	target = id
	target.draw_points = 100
	target.active = true
