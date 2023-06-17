extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"v


var explosion = preload("res://Scenes/Explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	contacts_reported = 10

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var collisions = get_colliding_bodies()
	for i in collisions:
		if i.name == "Ground":
			var new_explosion = explosion.instance()
			get_tree().get_root().add_child(new_explosion)
			new_explosion.transform.origin = transform.origin
			new_explosion.get_node("Fire").scale *= 0.25
			queue_free()
