extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shell_node = preload("res://Objects/DefaultShell.tscn")
var player
var angle = 0
var tree
export var energy_usage = 5
var level = 0
var dps = 10
var upgrader

# Called when the node enters the scene tree for the first time.
func _ready():
	tree = get_tree().get_root()
	player = tree.get_node("Root/Player")
	if player == null:
		printerr("BaseGun.gd: Is the player path correct?")
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	set_dps()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
#	angle = atan2(mouse_position.y - player_position.y, mouse_position.x - player_position.x) * 180 / PI
	
	look_at(get_global_mouse_position())
#	print(rotation_degrees)
	get_input()

func get_input():
	if Input.is_action_just_pressed("mouseLeft"):
		shoot()


# Try to shoot a shell, do energy stuff
func shoot():
	if player.can_use_energy(energy_usage):
		player.use_energy(energy_usage)
		spawn_shell()

# Create shell in the scene
func spawn_shell():
	var shell_instance = shell_node.instance()
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	shell_instance.set_position(player.position + mouse_dir * 70)
	shell_instance.set_rotation(mouse_dir.angle())
	shell_instance.set_velocity_direction(mouse_dir)
	shell_instance.set_damage(dps)
	
	tree.add_child(shell_instance)

func set_dps():
	var gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	if upgrader != null && gamemanager != null:
		dps = upgrader.shells_dps[gamemanager.data.shells_current_level]
	
