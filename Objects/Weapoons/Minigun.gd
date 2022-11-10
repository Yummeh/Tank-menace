extends Node2D

var level = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shell_node = preload("res://Objects/Bullet.tscn")
onready var audio := $MinigunShotSound
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
	set_dps()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
#	angle = atan2(mouse_position.y - player_position.y, mouse_position.x - player_position.x) * 180 / PI
	
	look_at(get_global_mouse_position())
#	print(rotation_degrees)
	get_input(delta)

func get_input(delta):
	if Input.is_action_pressed("mouseLeft"):
		shooting(delta)


var bullet_timing = 1
var bullet_timer_increase = 0.2
var bullet_counter = 1

# Try to shoot a shell, do energy stuff
func shooting(delta):
#	spawn_bullet()
	if bullet_counter >= bullet_timing:
		if player.can_use_energy(energy_usage):
			player.use_energy(energy_usage)
			bullet_counter -= bullet_timing
			spawn_bullet()
			audio.play()
			
	else:
		bullet_counter += bullet_timer_increase
	
	

# Create shell in the scene
func spawn_bullet():
	var bullet_instance = shell_node.instance()
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
#	var rand_vel_dir = (randi() % 50 - 25) * PI / 180
#	var rand_vel_vec = Vector2(cos(rand_vel_dir), sin(rand_vel_dir))
#	print(rand_vel_dir)
#
	
	bullet_instance.set_position(player.position + mouse_dir * 70)
	bullet_instance.set_rotation(mouse_dir.angle())
	bullet_instance.set_velocity_direction(mouse_dir)
	bullet_instance.set_damage(dps)
	
	tree.add_child(bullet_instance)

func set_dps():
	var gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	if upgrader != null && gamemanager != null:
		dps = upgrader.minigun_dps[gamemanager.data.minigun_current_level - 1]
