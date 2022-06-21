extends Node2D

var level = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var upgrader
var dps = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrader = get_tree().get_root().get_node("Root/Upgrader")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_dps():
	if upgrader != null:
		dps = upgrader.laser_dps[level]
	
