extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var building = preload("res://Scenes/Skyscraper.tscn")
var buildings = [
	preload("res://Scenes/BuildingPack2/Building01.tscn"),
	preload("res://Scenes/BuildingPack2/Building02.tscn"),
	preload("res://Scenes/BuildingPack2/Building03.tscn"),
	preload("res://Scenes/BuildingPack2/Building04.tscn"),
	preload("res://Scenes/BuildingPack2/Building05.tscn"),
	preload("res://Scenes/BuildingPack2/Building06.tscn"),
	preload("res://Scenes/BuildingPack2/Building07.tscn"),
	preload("res://Scenes/BuildingPack2/Building08.tscn"),
	preload("res://Scenes/BuildingPack2/Building09.tscn"),
	preload("res://Scenes/BuildingPack2/Building10.tscn"),
	preload("res://Scenes/BuildingPack2/Building11.tscn"),
	preload("res://Scenes/BuildingPack2/Building12.tscn"),
	preload("res://Scenes/BuildingPack2/Building14.tscn")
	]
	
var signage = preload("res://Scenes/NeonSign.tscn")
var shader_mat = preload("res://Scenes/NeonSignMaterial.tres")

var numOfSigns = 4
var shader_insts = []

var player = null

var loadingQueue = []
var loadingQueueBatchSize = 2

var navPointsGenerated = false
var numOfNavPoints = 500
var navPoints = []
var navPointQueueBatchSize = 100
var y_level_options = [5,7,11,14,18,21]

signal entered(s_id)
var section_width = null
var section_height = null

var width = null
var height = null
var chunk_height = null

class MyCustomSorter:
	static func sort_distance_to_origin(a, b):
		if a.distance_to(Vector3.ZERO) < b.distance_to(Vector3.ZERO):
			return true
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	width = $Area/CollisionShape.shape.get_extents().x*2
	height = $Area/CollisionShape.shape.get_extents().z*2
	chunk_height = $Area/CollisionShape.shape.get_extents().y*2
	var divisions = 8
	section_width = width / divisions
	section_height = height / divisions
	var building_spawn_chance = 0.65
	var num_of_desired_buildings = -1
	
	if num_of_desired_buildings != -1:
		var max_quantity = divisions^2
		if num_of_desired_buildings < max_quantity:
			building_spawn_chance = num_of_desired_buildings/max_quantity

	for section_z in range(0,height,section_height):
		for section_x in range(0,width,section_width):
			if randf() < building_spawn_chance:
				loadingQueue.append(Vector3(
					self.transform.origin.x - width/2 + section_x, 
					0, 
					self.transform.origin.z - height/2 + section_z))
					


func _process(_delta):
	if not loadingQueue.empty():
		if loadingQueueBatchSize == -1:
			loadingQueueBatchSize = len(loadingQueue)
		for _i in range(min(len(loadingQueue),loadingQueueBatchSize)):
			var pos = loadingQueue.pop_back()
			var index = randi() % len(buildings)
			var new_building = buildings[index].instance()
			$Buildings.add_child(new_building)
			new_building.rotation.y = randi() % 360
			new_building.scale *= rand_range(0.3,0.4)
			new_building.scale.y *= rand_range(1,1.5)
			var margin = new_building.get_node("Area").get_node("CollisionShape").shape.get_extents()
			new_building.transform.origin = Vector3(pos.x + rand_range(margin.x,section_width-margin.x),
													0,
													pos.z + rand_range(margin.z,section_height-margin.z))
			new_building.get_node("StaticBody/CollisionShape").disabled = false
			if Vector3.ZERO.distance_to(new_building.transform.origin) < 150:
				generate_signs(new_building)
			

func _physics_process(_delta):
	if loadingQueue.empty():
		if not navPointsGenerated and len(navPoints) < numOfNavPoints:
			if navPointQueueBatchSize == -1:
				navPointQueueBatchSize = numOfNavPoints
				
			for _i in range(min(numOfNavPoints - len(navPoints),navPointQueueBatchSize)):
				var y_level = y_level_options[randi() % len(y_level_options)]
				var scale_factor = .5
				var potential_point = Vector3(rand_range(-width*scale_factor,width*scale_factor),
											  y_level,
											  rand_range(-height*scale_factor,height*scale_factor))
				navPoints.append(potential_point)
			if len(navPoints) == numOfNavPoints:
				navPointsGenerated = true
				$TrafficManager.navPoints = navPoints
				if player != null:
					$TrafficManager.player = player
					player.connect("car_collision",$TrafficManager,"on_car_collision")
			
				

func _on_Area_body_entered(_body):
	emit_signal("entered",self)

func generate_signs(b):
	var new_building = b
	for _s in range(numOfSigns):
		var s = signage.instance()
		new_building.add_child(s)

		var extents = new_building.get_node("Area").get_node("CollisionShape").shape.get_extents()
		var shape_transform = new_building.get_node("Area").get_node("CollisionShape").transform.origin

		var side = 0 if randf() > 0.5 else 1
		var x_sign = 1 if randf() > 0.5 else -1
		var z_sign = 1 if randf() > 0.5 else -1

		if side:	# 0 = x, 1 = z
			z_sign *= rand_range(0,1)
			s.rotate_y(PI/2)
		else:
			x_sign *= rand_range(0,1)

		var y_range = rand_range(-.5,.5)
		s.transform.origin.x = shape_transform.x + extents.x * x_sign
		s.transform.origin.y = extents.y + extents.y * y_range
		s.transform.origin.z = shape_transform.z + extents.z * z_sign

		var shader_index = randi() % len(shader_insts)
		var Mat = shader_insts[shader_index]
		s.get_node("MeshInstance").material_override = Mat

		var sign_scale = rand_range(1.5,3)
		s.scale *= sign_scale
