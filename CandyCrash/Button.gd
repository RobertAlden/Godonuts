extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type = "Cash"
var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	text = type + ": " + str(amount)
	
func _on_Button_pressed():
	amount += 1
