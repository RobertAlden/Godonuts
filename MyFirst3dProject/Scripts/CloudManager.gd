extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cloud = preload("res://Cloud.tscn")
var numOfClouds = 10
var wind = Vector3(randf()*3,0,randf()*3)
var new_wind = null
# Called when the node enters the scene tree for the first time.
func _ready():
	while $Clouds.get_child_count() < numOfClouds:
		var new_cloud = cloud.instance()
		$Clouds.add_child(new_cloud)
		var region = get_parent().get_node("Area/CollisionShape").shape.get_extents()
		new_cloud.transform.origin = Vector3(rand_range(-region.x,region.x),
											 rand_range(-20,80),
											 rand_range(-region.z,region.z))
		new_cloud.transform.basis = transform.basis.rotated(transform.basis.y.normalized(), randf() * PI*2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if new_wind != null:
		wind = lerp(wind,new_wind, 0.025)
			
func _on_Timer_timeout():
	new_wind = Vector3(randf()*3,0,randf()*3)
	for c in $Clouds.get_children():
		c.velocity = wind
		if Vector3.ZERO.distance_to(c.transform.origin) > 150:
			c.die = true
			var new_cloud = cloud.instance()
			$Clouds.add_child(new_cloud)
			var region = get_parent().get_node("Area/CollisionShape").shape.get_extents()
			new_cloud.transform.origin = Vector3(rand_range(-region.x,region.x),
												 rand_range(-20,80),
												 rand_range(-region.z,region.z))
			new_cloud.transform.basis = transform.basis.rotated(transform.basis.y.normalized(), randf() * PI*2)


func _on_CloudUpdateTimer_timeout():
	for c in $Clouds.get_children():
		c.velocity = wind
