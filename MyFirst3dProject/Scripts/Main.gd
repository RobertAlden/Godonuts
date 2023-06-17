extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.


func _init():
	randomize()

func _ready():
	#OS.window_fullscreen = !OS.window_fullscreen

	var error_code = $Spaceship.connect("player_spawned", self, "on_player_spawn")
	if error_code != 0:
		print("ERROR: ", error_code)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("exit_app"):
		get_tree().quit()

func on_player_spawn():
	$ChunkManager.on_player_spawn()
