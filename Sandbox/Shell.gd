extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	angular_damp = 0
	apply_impulse(position,Vector2(-110*randf()-50,-100*randf()-50).rotated(rotation))
	angular_velocity = -1 - 15*randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$Particles2D.emitting = false

func _on_Timer2_timeout():
	queue_free()
