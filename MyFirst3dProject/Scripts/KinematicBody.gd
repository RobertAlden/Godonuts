extends KinematicBody


var min_flight_speed = 10
var max_flight_speed = 30
var turn_speed = 1.55
var roll_speed = 1.55
var pitch_speed = 1
var level_speed = 3.0
var throttle_delta = 30
var acceleration = 6.0

var forward_speed = 0
var target_speed = 0

var velocity = Vector3.ZERO
var turn_input = 0
var pitch_input = 0
var roll_input = 0

var roll_actual = 0

var grounded = false

var turn_deadzone = 0.05
var pitch_deadzone = 0.05


signal player_spawned()
var spawn_clear = false

signal car_collision(s_id,c_id)

func get_input(delta):
	var m_pos = get_viewport().get_mouse_position()
	var v_size = get_viewport().size
	var view_center = Vector2(v_size.x/2, v_size.y/2)
	var m_offset = m_pos - view_center
	
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if Input.is_action_pressed("throttle_down"):
		var limit = 0 if grounded else min_flight_speed
		target_speed = max(forward_speed - throttle_delta * delta, limit)
		
	turn_input = 0
	roll_input = 0
	if forward_speed > 0.5:
		turn_input = range_lerp(m_offset.x, -view_center.x, view_center.x, 1, -1)
		roll_input -= Input.get_action_strength("roll_right")
		roll_input += Input.get_action_strength("roll_left")
		
	pitch_input = 0
	if not grounded:
		pitch_input -= range_lerp(m_offset.y, 0, view_center.y, 0, 1)
	if forward_speed >= min_flight_speed:
		pitch_input += range_lerp(m_offset.y, 0, -view_center.y, 0, 1)
	
	if abs(pitch_input) < pitch_deadzone:
		pitch_input = 0
	
	if abs(turn_input) < turn_deadzone:
		turn_input = 0
	
	roll_actual = lerp(roll_actual, roll_input, 0.025)
	if roll_input == 0 and abs(roll_actual) > abs(roll_input):
		roll_actual = lerp(roll_actual, roll_input, 0.1)
		
		
	
func _physics_process(delta):
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.x.normalized(), pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y.normalized(), turn_input * turn_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.z.normalized(), roll_actual * roll_speed * delta)
	if grounded:
		$Mesh/MainCar.rotation.z = 0
	else:
		$Mesh/MainCar.rotation.z = lerp($Mesh/MainCar.rotation.z, -turn_input, level_speed * delta)
	
	
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
	velocity = -transform.basis.z * forward_speed
	if is_on_floor():
		if not grounded:
			rotation.x = 0
		velocity.y -= 1
		grounded = true
	else:
		grounded = false
	
	velocity = move_and_slide(velocity, Vector3.UP)
	var num_of_collisions = get_slide_count()
	for i in range(num_of_collisions):
		var collision = get_slide_collision(i)
		if collision.collider.name.begins_with("TrafficUnit"):
			emit_signal("car_collision", self, collision.collider.get_parent())



func _ready():
	pass

func _on_Timer_timeout():
	emit_signal("player_spawned")
