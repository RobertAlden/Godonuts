extends CharacterBody2D

# parameters/Idle/blend_position

@export var SPEED = 10000.0
@export var start_dir : Vector2 = Vector2(0, 1)

var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var anim_tree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(start_dir)

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	Input.get_vector("move_left","move_right","move_up","move_down")
	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
	var direction_y = Input.get_axis("move_up", "move_down")
	if direction_y:
		velocity.y = direction_y * SPEED * delta
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		
	print(direction_x, direction_y)
	
	update_animation_parameters(Vector2(direction_x,direction_y))
	pick_new_state()
	move_and_slide()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", move_input)
		anim_tree.set("parameters/Walk/blend_position", move_input)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
