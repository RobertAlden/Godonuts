extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var star_size = 2
var star_color = Color(255,255,255)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	draw_circle(Vector2.ZERO,star_size,star_color)
