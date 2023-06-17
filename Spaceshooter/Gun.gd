extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal firing(rotation,position)
signal fired(ind)

export(int) var index
var ready = true
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_Player_Shoot(ind):
	if index == ind:
		if ready:
			fire()
			ready = false
			if $Ready_Timer.is_stopped():
				$Ready_Timer.start()
				

func fire():
	emit_signal("firing",global_rotation,global_position)
	$Gun/Barrel.emitting = true
	


func _on_Timer_timeout():
	ready = true
	$Gun/Barrel.emitting = false
	emit_signal("fired",index)
	
