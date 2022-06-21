extends Node2D

var level = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shell_node = preload("res://Objects/Bullet.tscn")
var player
var angle = 0
var tree
export var energy_usage = 1
var upgrader
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

func _physics_process(delta):
	pass

func get_input():
	if Input.is_action_pressed("mouseLeft"):
		shooting()


# Try to shoot a shell, do energy stuff
func shooting():
	if player.can_use_energy(energy_usage):
		player.use_energy(energy_usage)
		spawn_bullet()

# Create shell in the scene
func spawn_bullet():
	var bullet_instance = shell_node.instance()
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	bullet_instance.set_position(player.position + mouse_dir * 70)
	bullet_instance.set_rotation(mouse_dir.angle())
	bullet_instance.set_velocity_direction(mouse_dir)
	bullet_instance.set_damage(dps)
	
	tree.add_child(bullet_instance)

func set_dps():
	if upgrader != null:
		dps = upgrader.minigun_dps[level]
	
