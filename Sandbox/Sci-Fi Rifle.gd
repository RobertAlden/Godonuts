extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s = preload("res://Shell.tscn")
var b = preload("res://Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Click"):
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("Fire")
	look_at(get_global_mouse_position())

func _on_EjectionPort_eject_shell(p):
	var sh = s.instance()
	get_tree().get_root().add_child(sh)
	sh.position = p
	

func _on_Barrel_fire_bullet(p,r):
	var bu = b.instance() 
	get_tree().get_root().add_child(bu)
	bu.position = p
	bu.rotation_degrees = r+rotation_degrees
	bu.apply_impulse(position,Vector2(3000,rand_range(-40,40)).rotated(bu.rotation))

	
