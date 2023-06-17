extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 5

var ideal_distance = 2
var follow_speed = 2
var max_speed = 6
var min_speed = 2
var follow_acceleration = 0.05

var progress = 0
var turn_rate = 0.5

var signalled = false
signal travel_complete(s_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if progress < 1:
		if $Start.transform.origin == $End.transform.origin:
			progress = 1
		else:
			var distance = $Start.transform.origin.distance_to($End.transform.origin)
			progress += speed/(distance+0.001) * delta
			var goal_transform = $Start.transform.interpolate_with($End.transform, progress+speed/(distance+0.1)*0.5)
			$Target.transform = $Target.transform.interpolate_with(goal_transform, delta)
			
			var distance_to_target = $TrafficUnit.transform.origin.distance_to($Target.transform.origin)
			if distance_to_target > ideal_distance:
				if follow_speed < max_speed:
					follow_speed += follow_acceleration
			else:
				if follow_speed > min_speed:
					follow_speed -= follow_acceleration*2
					
			follow_speed = clamp(follow_speed, min_speed, max_speed)
					
			$TrafficUnit.look_at($Target.global_transform.origin, Vector3.UP)
			$TrafficUnit.transform.origin = $TrafficUnit.transform.origin.move_toward($Target.transform.origin, follow_speed * delta)
	else:
		if not signalled:
			signalled = true
			emit_signal("travel_complete",self)
