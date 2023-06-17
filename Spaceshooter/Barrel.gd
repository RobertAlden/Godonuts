extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var emitting = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$"Muzzle Flash".emitting = emitting
	$"Muzzle Flash2".emitting = emitting
	
