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
onready var SwordAnimation := $GiantWalker/SwingSword
onready var GiantWalkerSprite := $GiantWalker
onready var GiantWalkerPhase2Sprite := $GiantWalkerStage2


var arrow = preload("res://Objects/BiggaBossArrow.tscn")
var rng = RandomNumberGenerator.new()

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
var playerInMeleeRange = false
var stageChangeMid = false

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
var dashDirection

var doMeleeNormal = false
var doMeleeStrong = false
var doRanged = false
var doSpawnCritters = false
var runAway = false


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
	yield(get_tree().create_timer(1.5), "timeout")
	print("end")
	pass

func _process(delta):
	HPBar.set_value(health as float / max_health as float * 100)
	HPLabel.set_text(health as String)
	
	
	match bossStage:
		BossStage.InitialStage:
#			Initial stage should be high chance of melee attacks, low chance of ranged attacks

			if stateChange:
				stateChange = false
				movementState = MovementState.SlowMoving
				doSomeInitialStageAttack()
			pass
		BossStage.MidStage:
#			Mid stage should be higher shance of ranged attacks and higher chance of dash followed by a melee attack
#			Could also dash away from player and do ranged attack
			if stateChange:
				stateChange = false
				movementState = MovementState.SlowMoving
				print("*******************")
				doSomeMidStageAttack()
#				doDash = true
#			print(doDash)
			if doDash:
				dash()
			
			pass
		BossStage.FinalStage:
#			Now spawns little critters and will do stronger melee attacks
			
			pass
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func doSomeInitialStageAttack():
#	If player is in range do melee attack otherwise do ranged attack
	yield(get_tree().create_timer(2.0), "timeout")
	rng.randomize()
	var my_random_number = rng.randi_range(0, 1)
	if playerInMeleeRange:
		print("Melee attack")
		movementState = MovementState.Running
		yield(get_tree().create_timer(1.0), "timeout")
		meleeAttack()
		movementState = MovementState.SlowMoving
		yield(get_tree().create_timer(1.0), "timeout")
		pass
	else:
		if my_random_number == 0:
			print("Ranged attack")
			rng.randomize()
			var random_multiple_shots = rng.randi_range(0, 1)
			
			movementState = MovementState.Charging
			yield(get_tree().create_timer(1.0), "timeout")
			rangedAttack()
			
			if random_multiple_shots == 1:
				yield(get_tree().create_timer(1.0), "timeout")
				rangedAttack()
				yield(get_tree().create_timer(1.0), "timeout")
				rangedAttack()
				
				
				
			yield(get_tree().create_timer(1.0), "timeout")
			movementState = MovementState.Running
			yield(get_tree().create_timer(1.0), "timeout")
			movementState = MovementState.SlowMoving
		else:
			
			print("Melee not on range attack")
			movementState = MovementState.Running
			yield(get_tree().create_timer(3.0), "timeout")
			meleeAttack()
			yield(get_tree().create_timer(0.5), "timeout")
			meleeAttack()
			yield(get_tree().create_timer(0.5), "timeout")
			meleeAttack()
			yield(get_tree().create_timer(0.5), "timeout")
			
			movementState = MovementState.SlowMoving
			yield(get_tree().create_timer(1.0), "timeout")
	
	doSomeInitialStageAttack()

func doSomeMidStageAttack():
#	If player is in range do melee attack otherwise do ranged attack
	yield(get_tree().create_timer(2.0), "timeout")

#	print()
	doDash = true
	rng.randomize()
	var my_random_number = rng.randi_range(0, 1)
	if playerInMeleeRange:
		print("Melee attack")
		movementState = MovementState.Running
		yield(get_tree().create_timer(1.0), "timeout")
		meleeAttack()
		movementState = MovementState.SlowMoving
		yield(get_tree().create_timer(1.0), "timeout")
		pass
	else:
		if my_random_number == 0:
			print("Ranged attack")
			rng.randomize()
			var random_multiple_shots = rng.randi_range(0, 1)
			
			movementState = MovementState.Charging
			yield(get_tree().create_timer(1.0), "timeout")
			rangedAttack()
			
			if random_multiple_shots == 1:
				yield(get_tree().create_timer(1.0), "timeout")
				rangedAttack()
				yield(get_tree().create_timer(1.0), "timeout")
				rangedAttack()
			yield(get_tree().create_timer(1.0), "timeout")
			movementState = MovementState.Running
			yield(get_tree().create_timer(1.0), "timeout")
			movementState = MovementState.SlowMoving
		else:
			print("Melee not on range attack")
			rng.randomize()
			var random_dashes = rng.randf_range(0, 1)
			print(random_dashes)
			if random_dashes >= 0.3:
				print("Do dashes")
				yield(get_tree().create_timer(1.0), "timeout")
				doDash = true
				
				print(doDash)
#				dash()
				meleeAttack()
				yield(get_tree().create_timer(1.0), "timeout")
				doDash = true
#				dash()
				meleeAttack()
			else:
				movementState = MovementState.Running
				yield(get_tree().create_timer(3.0), "timeout")
				meleeAttack()
				yield(get_tree().create_timer(0.5), "timeout")
				meleeAttack()
				yield(get_tree().create_timer(0.5), "timeout")
				meleeAttack()
				yield(get_tree().create_timer(0.5), "timeout")
			
			movementState = MovementState.SlowMoving
			yield(get_tree().create_timer(1.0), "timeout")
	stateChange = true

func meleeNormal():
	meleeAttack()
	pass
	
func meleeStrong():
	meleeAttack()
	pass
	
func meleeAttack():
	SwordAnimation.play("SwingSword")
	pass
	
func rangedAttack():
	var tree = get_tree().get_root()
	
	var arrow_instance = arrow.instance()
	var shootDirection = (player.position - position).normalized()
#	var rand_vel_dir = (randi() % 50 - 25) * PI / 180
#	var rand_vel_vec = Vector2(cos(rand_vel_dir), sin(rand_vel_dir))
#	print(rand_vel_dir)
#
	
	arrow_instance.set_position(position + shootDirection * 70)
	arrow_instance.set_rotation(shootDirection.angle())
	arrow_instance.set_velocity_direction(shootDirection)
	arrow_instance.set_damage(100)
	
	tree.add_child(arrow_instance)
#	yield(get_tree().create_timer(.5), "timeout")
#	rangedAttack()
	pass
	
func spawnCritters():
	pass


func dash():
	print("Dash")
	doDash = false
	should_follow_player = false

	dashLocation = player.position
	dashDirection = (dashLocation - position).normalized()
	
#	Wait before dashing
	yield(get_tree().create_timer(1), "timeout")
	dashing = true
	movementState = MovementState.Dash
#	Timer for dashing duration
	yield(get_tree().create_timer(0.2), "timeout")
	movementState = MovementState.SlowMoving
	
	
	dashing = false
	should_follow_player = true
	
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
		if health as float / max_health as float * 100 < 35 && !stageChangeMid:
			GiantWalkerSprite.hide()
			GiantWalkerPhase2Sprite.show()
			
			bossStage = BossStage.MidStage
			stageChangeMid = true
			stateChange = true
	
func dead():
	player.save_player_data()
	get_tree().change_scene("res://Scenes/EndScreen.tscn")
	
	
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
		
#	if should_follow_player:
#		move(delta)
#		look_at(player.global_position)
		
	bossMovement(delta)
	
func bossMovement(delta):
#	if movementState == MovementState.Still:

	
	match movementState:
		MovementState.Still:
			speed = 0
		MovementState.SlowMoving:
#			print("slow")
			speed = 50
		MovementState.Running:
			speed = 300
		MovementState.Dash:
			speed = 2000
			velocity = dashDirection * speed
			move(delta)
			look_at(dashLocation)
				
		MovementState.Charging:
			speed = 10
	
	if should_follow_player:
		look_at(player.global_position)
		generate_path()
		navigate()
		move(delta)
		
	
	
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


func _on_MeleeRange_body_entered(body):
	if body.name == "Player":
		playerInMeleeRange = true
	pass # Replace with function body.


func _on_MeleeRange_body_exited(body):
	if body.name == "Player":
		playerInMeleeRange = false
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
