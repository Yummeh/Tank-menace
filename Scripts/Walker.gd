extends KinematicBody2D

onready var collision := $CollisionShape2D
var health = 100
var damage = 100
var speed = 100

var player 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Root/YSort/Player")
	if player == null:
		printerr("Walker.gd: Player was not found in the scene, is the node path correct?")
	print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
##	target = player.position
##	print(target)
#	pass

func remove_health(points):
	if health - points <= 0:
		health = 0
		dead()
		player.add_money(10)
	else:
		health -= points
	print(health)
	
func dead():
	print("I am dead")
	queue_free()
	pass
