extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var center = null
var chunk = preload("res://Scenes/SkyscraperChunk.tscn")
var player = null
var positions = []
var connected = false
var world_width = 1
var shifting = false

var totalCarCount = 0

var shader_mat = preload("res://Scenes/NeonSignMaterial.tres")
var shader_insts = []

var chunk_size = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Spatial/Spaceship")
	for _i in 20:
		var shader = shader_mat.duplicate(DUPLICATE_USE_INSTANCING)
		shader.set_shader_param("HueOffset", rand_range(0,5))
		shader.set_shader_param("TimeOffset", rand_range(0,5000))
		shader_insts.append(shader)
	for x in range(-world_width,world_width+1):
		for z in range(-world_width,world_width+1):
			var new_chunk = chunk.instance()
			$Chunks.add_child(new_chunk)
			if x == 0 and z == 0:
				center = new_chunk
				new_chunk.loadingQueueBatchSize = -1
				new_chunk.navPointQueueBatchSize = -1
			var region = new_chunk.get_node("Area").get_node("CollisionShape").shape.get_extents()
			chunk_size = region
			new_chunk.transform.origin = Vector3(
				self.transform.origin.x + x*region.x*2, 
				0, 
				self.transform.origin.z + z*region.z*2)
			new_chunk.shader_insts = shader_insts
			positions.append(new_chunk.transform.origin)
	
func _process(_delta):
	if not connected:
		connect_children()
		connected = true

func on_player_spawn():
	for c in center.get_node("Buildings").get_children():
		if c.transform.origin.distance_to(Vector3.ZERO) < 10:
			c.queue_free()
		else:
			c.get_node("StaticBody/CollisionShape").disabled = false

func connect_children():
	for c in $Chunks.get_children():
		c.player = player
		c.connect("entered", self, "region_entered")

func region_entered(chunk_ref):
	if chunk_ref != center and not shifting:
		shifting = true
		$Timer.start()
		center = chunk_ref
		var offset = chunk_ref.transform.origin
		for c in $Chunks.get_children():
			for k in c.get_node("Buildings").get_children():
				k.get_node("StaticBody/CollisionShape").disabled = true
			c.transform.origin -= offset 
			for k in c.get_node("Buildings").get_children():
				k.get_node("StaticBody/CollisionShape").disabled = false
		player.transform.origin -= offset
		for c in $Chunks.get_children(): # clearing distant chunks
			var flag = false
			for p in positions:
				if p == c.transform.origin:
					flag = true
					break
			if not flag:
				c.queue_free()
		for p in positions: # spawning new chunks
			var flag = false
			for c in $Chunks.get_children():
				if p == c.transform.origin:
					flag = true
					break;
			if not flag:
				var new_chunk = chunk.instance()
				$Chunks.add_child(new_chunk)
				new_chunk.player = player
				new_chunk.transform.origin = p
				new_chunk.connect("entered", self, "region_entered")
				new_chunk.shader_insts = shader_insts
				
		

func _on_Timer_timeout():
	shifting = false
	
func _on_TrafficCountUpdate_timeout():
	totalCarCount = 0
	for c in $Chunks.get_children():
		var child_car_count = c.get_node("TrafficManager/LiveTraffic").get_child_count()
		if child_car_count > 0:
			totalCarCount += child_car_count
	print(totalCarCount)
	for c in $Chunks.get_children():
		 c.get_node("TrafficManager").totalCarCount = totalCarCount

func _on_VehicleBalanceUpdate_timeout():
	var max_dist = chunk_size.x * 2
	for c in $Chunks.get_children():
		var p_transform_ground = Vector3(player.transform.origin.x,0,player.transform.origin.z)
		var p_dist = p_transform_ground.distance_to(c.transform.origin)
		var max_cars = 200
		var car_quota = clamp(round(range_lerp(p_dist, 0, max_dist, max_cars, 0)), 0, max_cars)
		#print("Car Quota: ", car_quota, ", Current Amount: ", c.get_node("TrafficManager/LiveTraffic").get_child_count())
		c.get_node("TrafficManager").num_of_cars = car_quota
		
