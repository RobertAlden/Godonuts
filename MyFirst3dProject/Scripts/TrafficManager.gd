extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var traffic = preload("res://Scenes/TrafficUnit.tscn")
var trafficPhysics = preload("res://Scenes/PhysicsTrafficUnit.tscn")

var cars = [
	preload("res://Scenes/Cars/FamilyCar.tscn"),
	preload("res://Scenes/Cars/Limo.tscn"),
	preload("res://Scenes/Cars/Lorry.tscn"),
	preload("res://Scenes/Cars/MuscleCar.tscn"),
	preload("res://Scenes/Cars/Racecar.tscn"),
	preload("res://Scenes/Cars/Sedan.tscn"),
	preload("res://Scenes/Cars/PickupTruck.tscn")
]

var navPoints = null
var num_of_cars = 0
var totalCarCount = 0
var carBatchSize = 10

var active = true
var newPathQueue = []
var newPathQueueBatchSize = 25

var deleteQueue = []
var deleteQueueBatchSize = 50

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var space_state = get_world().direct_space_state
	if navPoints != null: # given a list of navPoints
		if num_of_cars > $LiveTraffic.get_child_count():
			for _i in range(min(num_of_cars - $LiveTraffic.get_child_count(), carBatchSize)):
				var new_car = traffic.instance() #instantiate new car
				$LiveTraffic.add_child(new_car)
				var index = randi() % len(cars) # assign model
				var model = cars[index].instance() 
				new_car.get_node("TrafficUnit/Model").add_child(model)
				var model_shape = model.get_node("CollisionShape").shape
				new_car.get_node("TrafficUnit/CollisionShape").shape = model_shape
				var start = null # select start point
				var flag = false
				for _n in range(floor(len(navPoints)/10.0)): # sample a few possible start points
					var start_index = randi() % len(navPoints)
					start = navPoints[start_index]
					var sky_point = Vector3(start.x,100,start.z)
					var can_see_sky_collision_result = space_state.intersect_ray(start,sky_point) # ensure not spawned within a building 
					if not can_see_sky_collision_result:
						var collision_results = space_state.intersect_ray(player.global_transform.origin,start) # ensure out of sight
						if collision_results:
							if "Building" in collision_results["collider"].get_parent().name:
								flag = true
								break
							elif "Spaceship" in collision_results["collider"].get_parent().name:
								break
					else:
						navPoints.erase(start) # destroy internal points if invalid
				if flag: # if all checks succeed, add car to path queue, otherwise discard attempt
					new_car.get_node("TrafficUnit").transform.origin = start
					new_car.get_node("Start").transform.origin = start
					new_car.get_node("End").transform.origin = start
					new_car.connect("travel_complete", self, "on_travel_complete")
					newPathQueue.append(new_car)
				else: 
					new_car.queue_free()

	if not deleteQueue.empty():
		for _i in min(deleteQueueBatchSize, len(deleteQueue)):
			var c = deleteQueue[randi() % len(deleteQueue)]
			if c != null and is_instance_valid(c):
				var collision_results = space_state.intersect_ray(player.global_transform.origin,
																  c.get_node("TrafficUnit").transform.origin)
				if collision_results: 
					if "Building" in collision_results["collider"].get_parent().name:
						newPathQueue.erase(c)
						deleteQueue.erase(c)
						c.queue_free()
					else:
						newPathQueue.append(c)
						deleteQueue.erase(c)
				else:
					newPathQueue.append(c)
					deleteQueue.erase(c)

	if not newPathQueue.empty():
		for _p in min(len(newPathQueue),newPathQueueBatchSize):
			var unit = newPathQueue.pop_back()
			if unit != null and is_instance_valid(unit):
				unit.progress = 0
				unit.signalled = false				
				var new_end = null	
				var flag = false
				for _i in range(floor(len(navPoints)/10.0)):
					var new_end_index = randi() % len(navPoints)
					new_end = navPoints[new_end_index]
					var collision_results = space_state.intersect_ray(unit.get_node("End").transform.origin,new_end)
					if not collision_results:
						flag = true
						break
				if flag:
					unit.get_node("Start").transform.origin = unit.get_node("End").transform.origin
					unit.get_node("Target").transform = unit.get_node("Start").transform
					unit.get_node("End").transform.origin = new_end
				else:
					deleteQueue.append(unit)
					



func on_travel_complete(t_id):
	var child_count = $LiveTraffic.get_child_count()
	if num_of_cars > child_count:
		if not t_id in newPathQueue:
			newPathQueue.append(t_id)
	else:
		var threshold = range_lerp(child_count,0,num_of_cars,0,1)
		if randf() < threshold:
			deleteQueue.append(t_id)
		else:
			newPathQueue.append(t_id)

func on_car_collision(p,c_id): # swaps trafficunit for identical physics dummy on collision
	var new_physics_dummy = trafficPhysics.instance()
	$PhysicsDummies.add_child(new_physics_dummy)
	var model = c_id.get_node("TrafficUnit").get_node("Model").duplicate(DUPLICATE_USE_INSTANCING)
	new_physics_dummy.add_child(model)
	new_physics_dummy.transform = c_id.get_node("TrafficUnit").transform
	new_physics_dummy.apply_impulse(p.transform.origin,Vector3(0,5,0))
	newPathQueue.erase(c_id)
	deleteQueue.erase(c_id)
	c_id.queue_free()
