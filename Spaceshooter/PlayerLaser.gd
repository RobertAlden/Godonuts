extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var speed = 1500

signal boom(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	velocity = Vector2(0, speed).rotated(rotation)
	velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	queue_free()
	emit_signal("boom",global_position)
	

