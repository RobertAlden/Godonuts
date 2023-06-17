extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _error = $"Player/Sprite/Left Gun".connect("firing",$"Player Projectiles","_on_Firing")
	_error = $"Player/Sprite/Right Gun".connect("firing",$"Player Projectiles","_on_Firing")
	$Enemies.player = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
