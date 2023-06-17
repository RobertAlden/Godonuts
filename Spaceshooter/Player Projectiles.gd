extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Laser = preload("res://PlayerLaser.tscn")
var explosion = preload("res://Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Firing(direction,location):
	var p = Laser.instance()
	add_child(p)
	p.connect("boom",self,"_on_boom")
	p.position = location
	p.rotation = direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_boom(p):
	var e = explosion.instance()
	add_child(e)
	e.position = p
