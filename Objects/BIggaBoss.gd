extends KinematicBody2D

onready var collision := $CollisionShape2D
var deathSoundObject = preload("res://Sounds/DeathSoundObject.tscn")
var coinObject = preload("res://Objects/Coin.tscn")
onready var hitAudio := $HitSound
export var max_health = 100
export var health = 100
export var damage = 100
export var speed = 100
export var gold_worth = 40
export var type = "BaseEnemy"
var player 
onready var HPBar := $Node2D/HPBar
onready var HPLabel := $Node2D/HPLabel

enum BossStage {
	None
	InitialStage
	MidStage
	FinalStage
}

enum AttackState {
	Waiting
	MeleeNormal
	MeleeStrong
	Aim
	Shoot
	Spawning
}

enum MovementState {
	Still
	Charging
	SlowMoving
	Running
	Dash
}

var attackState = AttackState.Waiting
var movementState = MovementState.Still
var bossStage = BossStage.None
var isAggro = false
var fightHasStarted = false


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

var doDash = false
var dashing = false
var dashLocation

# Called when the node enters the scene tree for the first time.
func _ready():
#	timer.wait_time = 1.0
#	timer.connect("timeout",self,"_on_timer_timeout") 
	
	player = get_tree().get_root().get_node("Root/Player")
	if player == null:
		printerr("Walker.gd: Player was not found in the scene, is the node path correct?")
	
	level_navigation = get_tree().get_root().get_node("Root/LevelNavigation")
	if level_navigation == null:
		printerr("Walker.gd: Level navigation was not found in the scene, is the node path correct?")
	
	
	pass # Replace with function body.

var stateChange = false

func ok():
	print("start")
	yield(get_tree().create_timer(3.0), "timeout")
	print("end")
	
	doDash = true
	print("ok")
	
	pass

func _process(delta):
	HPBar.set_value(health as float / max_health as float * 100)
	HPLabel.set_text(health as String)
	
	match bossStage:
		BossStage.InitialStage:
			if doDash:
				dash()
			
			if stateChange:
				stateChange = false
				movementState = MovementState.SlowMoving
				ok()
#				var huh = funcref(self, "ok")
				
#				waitForNextMove(huh)
				
				
			
			
			pass
		BossStage.MidStage:
			pass
		BossStage.FinalStage:
			pass
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func dash():
	doDash = false
	should_follow_player = false
	
#	Wait before dashing
	yield(get_tree().create_timer(1), "timeout")
	dashing = true
	movementState = MovementState.Dash
	dashLocation = player.position
#	Timer for dashing duration
	yield(get_tree().create_timer(1), "timeout")
	movementState = MovementState.SlowMoving
	dashing = false
	should_follow_player = true
	print("stop dash")

func waitForNextMove(function):
	timer.wait_time = 1.0
	timer.connect("timeout",self, "_on_timer_timeout") 
	function.call_func()
	pass

func remove_health(points):
	if health - points <= 0:
		health = 0
		dead()
	else:
		health -= points
	
func dead():
	var tree = get_tree().get_root()
	var deathSoundObjectInstance = deathSoundObject.instance()
	deathSoundObjectInstance.set_position(global_position)
	tree.add_child(deathSoundObjectInstance)
	
	var coinObjectInstance = coinObject.instance()
	coinObjectInstance.set_money(gold_worth)
	coinObjectInstance.set_position(global_position)
	tree.add_child(coinObjectInstance)
	
	queue_free()
	pass

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	
#	Generate path to player when it has seen player
#	if should_follow_player and isAggro and player and level_navigation:
#		generate_path()
#		navigate()
#
#	bossMovement(delta)
#
#	move(delta)
	
	if should_follow_player and player and level_navigation:
		generate_path()
#		navigate()
		
	if should_follow_player:
		move(delta)
		look_at(player.global_position)
		
	bossMovement(delta)
	
func bossMovement(delta):
#	if movementState == MovementState.Still:

	
	match movementState:
		MovementState.Still:
			speed = 0
		MovementState.SlowMoving:
			speed = 50
		MovementState.Running:
			speed = 300
		MovementState.Dash:
			speed = 1000
		MovementState.Charging:
			speed = 10
	
	if should_follow_player:
		look_at(player.global_position)
		generate_path()
		navigate()
		
	if dashing:
		var forward = (dashLocation - position).normalized()
		print(velocity)
		
		velocity = forward * speed
	
func move(delta):
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
#			timer.start()
			
			collision.collider.remove_health(damage * delta)

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
	if !fightHasStarted and boolean:
		print("Start")
		isAggro = true
		fightHasStarted = true
		stateChange = true
		bossStage = BossStage.InitialStage
	
	should_follow_player = boolean
