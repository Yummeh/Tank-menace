extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shell_node = preload("res://Objects/DefaultShell.tscn")
var player
var angle = 0
var tree
var upgrader
export var energy_usage = 40
export var current_damaging_enemies = []
var level = 0
var dps = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	tree = get_tree().get_root()
	player = tree.get_node("Root/Player")
	if player == null:
		printerr("BaseGun.gd: Is the player path correct?")
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = get_global_transform()[2]
	var mouse_position = get_global_mouse_position()
		
#	angle = atan2(mouse_position.y - player_position.y, mouse_position.x - player_position.x) * 180 / PI
	
	look_at(get_global_mouse_position())
#	print(rotation_degrees)
	get_input()
	if current_damaging_enemies.size() > 0 && player.can_use_energy(energy_usage * delta):
		player.use_energy(energy_usage * delta)
		for enemy in current_damaging_enemies:
			enemy.remove_health(dps * delta)


func _physics_process(delta):
	pass

func get_input():
	if Input.is_action_pressed("mouseLeft"):
		shooting()


# Try to shoot a shell, do energy stuff
func shooting():
	if player.can_use_energy(energy_usage):
		player.use_energy(energy_usage)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		current_damaging_enemies.append(body)

func _on_Area2D_body_exited(body):
	if body.is_in_group("Enemy"):
		current_damaging_enemies.erase(body)

func set_dps():
	if upgrader != null:
		dps = upgrader.spiked_dps[level]
	
