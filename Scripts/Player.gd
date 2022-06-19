extends KinematicBody2D

export (int) var speed = 300
export var max_health = 100
export var current_health = 100
export var accuracy = 25 #in degrees
export var energy = 100
export var damage = 100
export var driving_energy_usage = 13 # per second
export var money = 0

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
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
	look_at(position + velocity.normalized())

func use_energy(number):
	if energy - number >= 0:
		energy -= number

func can_use_energy(number):
	return energy - number >= 0
	
func add_money(number):
	money += number
