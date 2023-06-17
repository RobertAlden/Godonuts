extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dead = false
onready var bt = $Node2D/bullettrail
# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(position,Vector2(3000,rand_range(-40,40)).rotated(rotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bt.add_point(global_position)
	
func _on_Timer_timeout():
	dead = true
	bt.stop()
	queue_free()
		

func _on_Bullet_body_entered(body):
	gravity_scale = 10
	mass = 500
	dead = true
	#bt.stop()
