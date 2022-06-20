extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Root/Player")
	if player == null:
		printerr("WalkerSeesPlayer.gd: Player was not found in the scene, is the node path correct?")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_parent().follow_player(true)
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		get_parent().follow_player(false)
		print("exit")
	pass # Replace with function body.


