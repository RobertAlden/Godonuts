extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3(randf()*3,0,randf()*3)
var die = false
var dying = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	transform.origin += velocity * delta
	if die and not dying:
		dying = true
		$Particles.emitting = false
		$Timer.start()


func _on_Timer_timeout():
	queue_free()
