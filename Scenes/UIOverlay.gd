extends Control

onready var NRGValue = $EnergyBar/NRGValue
onready var HPValue = $HPBar/HPValue
onready var GoldValue = $Gold/Label
onready var HPBar = $HPBar
onready var NRGBar = $EnergyBar

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var gamemanager

var max_hp
var max_nrg
var upgrader
var money

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
		GoldValue.set_text("Gold: " + player.money as String)
		NRGBar.set_value(floor(player.energy) / max_nrg * 100)
		HPBar.set_value(floor(player.current_health) / max_hp * 100)
		pass
	
	pass
