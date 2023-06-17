extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal fire_bullet(p,r)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire_bullet():
	emit_signal("fire_bullet",global_position,global_rotation_degrees)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
