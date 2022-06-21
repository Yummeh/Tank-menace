extends KinematicBody2D

export (int) var speed = 300
export var max_health = 100
export var current_health = 100
export var accuracy = 25 #in degrees
export var energy = 100
export var driving_energy_usage = 13 # per second

export var money = 0
export var hp_current_level = 0
export var acc_current_level = 0
export var spd_current_level = 0
export var nrg_current_level = 0
export var weapon_selected = 0
export var weapons_unlocked = [0]
export var shells_current_level = 0
export var minigun_current_level = 0
export var spiked_current_level = 0
export var laser_current_level = 0

#var shell_node = preload("res://Objects/Weapons/DefaultShell.tscn")
var shellgun = preload("res://Objects/Weapoons/BaseGun.tscn")
var minigun = preload("res://Objects/Weapoons/Minigun.tscn")
var spiked = preload("res://Objects/Weapoons/Spiked.tscn")
var laser = preload("res://Objects/Weapoons/LaserGun.tscn")


var velocity = Vector2()

var debug
var upgrader
var spawned_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	get_player_data()
	
	
#	debug = get_tree().get_root().get_node("Root/CanvasLayer/DebugStats")
#	debug.add_property(self, "velocity", "length")
#	debug.add_property(self, "energy", "")
#	debug.add_property(self, "current_health", "")
#	debug.add_property(self, "money", "")
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	if upgrader != null:
		set_weapon(weapon_selected)

#	speed = upgrader.
		max_health = upgrader.player_hp_data[hp_current_level]
		current_health = max_health
		speed = upgrader.player_spd_data[spd_current_level]
		energy = upgrader.player_nrg_data[nrg_current_level]
		accuracy = upgrader.player_acc_data[acc_current_level]
	

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	if velocity.x != 0 || velocity.y != 0 && energy > 0:
		use_energy(delta * driving_energy_usage)


func get_input():
	if Input.is_action_pressed("Home"):
		save_player_data()
		get_tree().change_scene("res://Scenes/StartMenu.tscn")
	
	velocity = Vector2()
	if energy > 0:
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
	
	velocity = velocity.normalized() * speed


func _process(delta):
	turn()
	
#Slow rotation not needed for now
func turn():
	var rotation_speed = 0.01
	look_at(global_position + velocity.normalized())

func use_energy(number):
	if energy - number >= 0:
		energy -= number
		if energy == 0:
			dead()
	else:
		energy = 0
		dead()

func can_use_energy(number):
	return energy - number >= 0
	
func add_money(number):
	money += number

func remove_health(number):
	if current_health - number > 0:
		current_health -= number
	else:
		current_health = 0
		dead()
		
		
func dead():
	save_player_data()
	get_tree().change_scene("res://Scenes/UpgradeScene.tscn")
	pass

func save_player_data():
	var player_data = {
			"money": money,
			"hp_current_level": hp_current_level,
			"spd_current_level": spd_current_level,
			"nrg_current_level": nrg_current_level,
			"acc_current_level": acc_current_level,
			"weapons_unlocked": weapons_unlocked,
			"shells_current_level": shells_current_level,
			"minigun_current_level": minigun_current_level,
			"spiked_current_level": spiked_current_level,
			"laser_current_level": laser_current_level,
			"weapon_selected": weapon_selected
	}
	var gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	gamemanager.set_player_data(player_data)
	gamemanager.save_game()
	
func get_player_data():
	var gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	gamemanager.load_save()
	var player = gamemanager.data
	money = player.money 
	hp_current_level = player.hp_current_level
	spd_current_level = player.spd_current_level
	nrg_current_level = player.nrg_current_level
	acc_current_level = player.acc_current_level
	weapons_unlocked = player.weapons_unlocked
	shells_current_level = player.shells_current_level
	minigun_current_level = player.minigun_current_level
	spiked_current_level = player.spiked_current_level
	laser_current_level = player.laser_current_level
	weapon_selected = player.weapon_selected


func set_weapon(number):
	if spawned_weapon != null:
		spawned_weapon.queue_free()
	var weapon
	var weapon_instance_level
	match number as int:
		0:
			weapon = shellgun
			weapon_instance_level = shells_current_level
		1:
			weapon = minigun
			weapon_instance_level = minigun_current_level
		2:
			weapon = spiked
			weapon_instance_level = spiked_current_level
		3:
			weapon = laser
			weapon_instance_level = laser_current_level
			
	if weapon == null:
		return
	
	spawned_weapon = weapon.instance()
	spawned_weapon.level = weapon_instance_level
	add_child(spawned_weapon)

	pass
