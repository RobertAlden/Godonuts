extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nodes = 50
var num_of_clusters = 4

var cluster_size = 80
var margin = Vector2(1.92,1.08)

var size = 550
var minimum_dist = 65
var connection_dist = 120
var node_list = []
var system = preload("res://Scenes/System.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in num_of_clusters:
		var offset = randf() * TAU
		var cluster_position = Vector2.RIGHT.rotated(PI/2 * i + PI/4) * margin * 600
		for k in floor(nodes/num_of_clusters):
			if len(node_list) > 0:
				while true:
					var dir = randi() % 360
					var dist = randi() % size
					var n = cluster_position + (Vector2.RIGHT.rotated(dir)) * dist
					var failure = false
					for node in node_list:
						if n.distance_to(node) < minimum_dist:
							failure = true
					if !failure:
						node_list.append(n)
						var s = system.instance()
						$Systems.add_child(s)
						s.position = n
						break
			else:
				var dir = randi() % 360
				var dist = randi() % cluster_size
				var n = cluster_position + (Vector2.RIGHT.rotated(dir)) * dist
				node_list.append(n)
				var s = system.instance()
				$Systems.add_child(s)
				s.position = n
		
	for c in $Systems.get_children():
		var times = 1
		if randf() < 0.3:
			times += randi() % 3 + 1
		for i in times:
			var failure = true
			var bonus_dist = 0
			while true:
				var other_c = $Systems.get_children()[randi() % $Systems.get_child_count()]
				if c.position.distance_to(other_c.position) <= (connection_dist + bonus_dist):
					if c != other_c:
						if not (other_c in c.connections) and not (c in other_c.connections):
							c.connections.append(other_c)
							other_c.connections.append(c)
							failure = false
				if not failure:
					break
				else:
					bonus_dist += 1
	
	var all_nodes = $Systems.get_children()
	var clusters = []
	while true:
		var new_cluster = []
		var search_stack = []
		var start_node = null
		while true: # select an untraversed node
			var failure = false
			start_node = all_nodes[randi() % len(all_nodes)]
			if len(clusters) > 0:
				for c in clusters:
					if start_node in c:
						failure = true
			if not failure:
				break
		
		search_stack.append(start_node)

		while len(search_stack) > 0:
			var n = search_stack.pop_back()
			if not (n in new_cluster):
				new_cluster.append(n)
			for conn in n.connections:
				if not (conn in search_stack) and not (conn in new_cluster):
					search_stack.append(conn)
		
		clusters.append(new_cluster)
		
		var total_len = 0
		for i in clusters:
			total_len += len(i)
		if total_len == len(all_nodes):
			break
	
	while len(clusters) > 1:
		var c1 = clusters.pop_back()
		var c2 = clusters.pop_back()	
		var smallest_dist = INF
		var selected_n1 = null
		var selected_n2 = null
		for n1 in c1:
			for n2 in c2:
				var dist_to_check = n1.position.distance_squared_to(n2.position)
				if dist_to_check < smallest_dist:
					smallest_dist = dist_to_check
					selected_n1 = n1
					selected_n2 = n2
					
		selected_n1.connections.append(selected_n2)
		selected_n2.connections.append(selected_n1)	
		var new_cluster = c1 + c2
		clusters.append(new_cluster)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

