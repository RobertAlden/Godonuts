extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null:
		var target = player.get_node("FrontCameraHandle").global_transform
		print(target.origin)
		transform = target
	else:
		player = get_tree().get_root().get_node("Spatial/Spaceship")
