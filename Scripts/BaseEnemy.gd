extends KinematicBody2D

onready var collision := $CollisionShape2D
var health = 100
var damage = 100
var speed = 100
var type = "BaseEnemy"
var player 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = Vector2()
var velocity = Vector2.ZERO

var path: Array = []
var level_navigation: Navigation2D = null
onready var line2d = $Line2D

var timer := Timer.new()
var should_follow_player = false


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = 1.0
	timer.connect("timeout",self,"_on_timer_timeout") 

	
	player = get_tree().get_root().get_node("Root/Player")
	if player == null:
		printerr("Walker.gd: Player was not found in the scene, is the node path correct?")
	
	level_navigation = get_tree().get_root().get_node("Root/LevelNavigation")
	if level_navigation == null:
		printerr("Walker.gd: Level navigation was not found in the scene, is the node path correct?")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

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

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if should_follow_player and player and level_navigation:
		generate_path()
		navigate()
		
	if should_follow_player:
		move()
		look_at(player.global_position)
	
func move():
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
#			timer.start()
			
			collision.collider.remove_health(10)

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		if global_position == path[0]:
			path.pop_front()
	
	
func generate_path():
	if player != null && level_navigation != null:
		path = level_navigation.get_simple_path(global_position, player.global_position, false)
		line2d.points = path
		
func _on_timer_timeout():
	print("TIme")

func follow_player(boolean):
	should_follow_player = boolean
