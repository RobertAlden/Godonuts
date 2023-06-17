extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
var state = "Patrol"
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == "Patrol":
		#if global_position.distance_to($"Move Target".global_position) > 5:
		if true:
			var angle_to_player = global_position.angle_to(player.global_position)
			rotation = lerp(rotation,angle_to_player,0.1)
			print(rotation,angle_to_player)
			move_and_slide(velocity)
