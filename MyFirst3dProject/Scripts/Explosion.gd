extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var decay = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	decay -= .5 * delta
	$OmniLight.light_energy = max(rand_range(0.8,2) * decay,0)

func _on_Timer_timeout():
	queue_free()
