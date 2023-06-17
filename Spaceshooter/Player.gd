extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 10
var rotation_speed = .35
var velocity = Vector2()
var rotation_dir = 90
var rotation_friction = 0.9
var rotation_velocity = 0
var friction = 0.98

var gun_index = 0
var guns = 2

signal Shoot(ind)

# Called when the node enters the scene tree for the first time.
func _ready():
	var _e = connect("Shoot",$"Sprite/Left Gun","_on_Player_Shoot")
	_e = connect("Shoot",$"Sprite/Right Gun","_on_Player_Shoot")
	_e = $"Sprite/Left Gun".connect("fired",self,"on_fired")
	_e = $"Sprite/Right Gun".connect("fired",self,"on_fired")

func get_input():
	$"Sprite/Left Thruster/Thruster".emitting = false
	$"Sprite/Right Thruster/Thruster".emitting = false
	$"Sprite/Front Thruster/Thruster".emitting = false
	if Input.is_action_pressed("turn_right"):
		rotation_velocity += rotation_speed
		$"Sprite/Left Thruster/Thruster".emitting = true
		
	if Input.is_action_pressed("turn_left"):
		rotation_velocity -= rotation_speed
		$"Sprite/Right Thruster/Thruster".emitting = true
		
	if Input.is_action_pressed("left"):
		velocity += Vector2(0,-speed).rotated(rotation)
	if Input.is_action_pressed("right"):
		velocity += Vector2(0,speed).rotated(rotation)
	if Input.is_action_pressed("backwards"):
		velocity += Vector2(-speed, 0).rotated(rotation)
		$"Sprite/Front Thruster/Thruster".emitting = true
	if Input.is_action_pressed("forward"):
		velocity += Vector2(speed, 0).rotated(rotation)
		$"Sprite/Left Thruster/Thruster".emitting = true
		$"Sprite/Right Thruster/Thruster".emitting = true
		
	if Input.is_action_pressed("shoot"):
		emit_signal("Shoot",gun_index)

func _physics_process(delta):
	get_input()
	rotation += rotation_velocity * delta
	velocity = move_and_slide(velocity)
	velocity *= friction
	rotation_velocity *= rotation_friction

func on_fired(ind):
	gun_index = (ind + 1) % guns
