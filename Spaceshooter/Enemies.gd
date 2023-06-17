extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
var enemy = preload("res://Enemy.tscn")
var max_enemies = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_child_count() < max_enemies:
		var e = enemy.instance()
		add_child(e)
		e.position = Vector2(rand_range(-1000,1000),rand_range(-1000,1000))
		e.player = player
		
