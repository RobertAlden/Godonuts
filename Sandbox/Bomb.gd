extends Node2D



var explo = preload("res://Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("Click"):
		var pos = get_global_mouse_position()
		var e = explo.instance()
		add_child(e)
		e.position = pos
