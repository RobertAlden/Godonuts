extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var player = null
export(NodePath) var target = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if target != null:
		var target_node = get_node(target)
		transform = target_node.global_transform

