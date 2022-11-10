extends Control

onready var NRGValue = $EnergyBar/NRGValue
onready var HPValue = $HPBar/HPValue
onready var GoldValue = $Gold/Label
onready var HPBar = $HPBar
onready var NRGBar = $EnergyBar
onready var warningAnimation := $WarningAnimation

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var gamemanager

var max_hp
var max_nrg
var upgrader
var money

var warningHealth = false
var warningEnergy = false


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Root/Player")
	gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	
	if player != null && gamemanager != null && upgrader != null:
		max_hp = upgrader.player_hp_data[gamemanager.data.hp_current_level]
		max_nrg = upgrader.player_nrg_data[gamemanager.data.nrg_current_level]
		money = player.money
#		print(gamemanager.data.hp_current_lvl)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null && gamemanager != null:
		money = player.money
		HPValue.set_text(floor(player.current_health) as String + " / " + max_hp as String)
		NRGValue.set_text(floor(player.energy) as String + " / " + max_nrg as String)
		GoldValue.set_text(player.money as String)
		NRGBar.set_value(floor(player.energy) / max_nrg * 100)
		HPBar.set_value(floor(player.current_health) / max_hp * 100)
		
		if (floor(player.current_health) / max_hp * 100) < 30:
			warningHealth = true
		else:
			warningHealth = false
			
		if (floor(player.energy) / max_nrg * 100) < 30:
			warningEnergy = true
		else:
			warningEnergy = false
		
		setWarningScreen()
	pass


func setWarningScreen():
	
	if warningEnergy && warningHealth:
		if warningAnimation.current_animation != "WarningHealthNEnergy":
			warningAnimation.play("WarningHealthNEnergy")
		return
	
	if warningEnergy:
		if warningAnimation.current_animation != "WarningEnergy":
			warningAnimation.play("WarningEnergy")
		return
	
	if warningHealth:
		if warningAnimation.current_animation != "WarningHealth":
			warningAnimation.play("WarningHealth")
		return

