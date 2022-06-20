extends KinematicBody2D

export (int) var speed = 300
export var max_health = 100
export var current_health = 100
export var accuracy = 25 #in degrees
export var energy = 100
export var damage = 100
export var driving_energy_usage = 13 # per second
export var money = 0

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
#	debug = get_tree().get_root().get_node("Root/CanvasLayer/DebugStats")
#	debug.add_property(self, "velocity", "length")
#	debug.add_property(self, "energy", "")
#	debug.add_property(self, "current_health", "")
#	debug.add_property(self, "money", "")
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	if upgrader != null:
		set_weapon(upgrader.player_gun_selected)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	if velocity.x != 0 || velocity.y != 0 && energy > 0:
		energy -= delta * driving_energy_usage


func get_input():
	velocity = Vector2()
	if energy > 0:
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			set_weapon(2)
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
	get_tree().change_scene("res://Scenes/UpgradeScene.tscn")
	pass

func set_weapon(number):
	if spawned_weapon != null:
		spawned_weapon.queue_free()
	var weapon
	
	match number:
		0:
			weapon = shellgun
		1:
			weapon = minigun
		2:
			weapon = spiked
		3:
			weapon = laser
			
	if weapon == null:
		return
	
	spawned_weapon = weapon.instance()
	add_child(spawned_weapon)
	pass
