extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var expl = preload("res://explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var e = expl.instance()
		add_child(e)
		e.position = InputEventMouseButton.position
