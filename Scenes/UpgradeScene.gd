extends Control

onready var gamemanager = $Gamemanager
onready var upgrader = $upgrader
onready var HPDisplay = $HPDisplay
onready var MoneyDisplay = $MoneyDisplay
onready var NRGDisplay = $NRGDisplay
onready var SPDDisplay = $SPDDisplay
onready var ACCDisplay = $ACCDisplay

onready var HPUpgrade = $HPUpgrade
onready var NRGUpgrade = $NRGUpgrade
onready var SPDUpgrade = $SPDUpgrade
onready var ACCUpgrade = $ACCUpgrade

onready var WeaponDisplay = $WeaponDisplay
onready var WeaponUpgrade = $UpgradeWeapon

var weapon_displayed = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_data

# Called when the node enters the scene tree for the first time.
func _ready():
	gamemanager.load_save()
	player_data = gamemanager.data
#	player_data.weapons_unlocked = [0, 1, 2, 3]
	print(player_data.weapons_unlocked)
	weapon_displayed = player_data.weapon_selected
	
	render_data()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	gamemanager.set_player_data(player_data)
	gamemanager.save_game()
	get_tree().change_scene("res://Scenes/StartMenu.tscn")
	pass # Replace with function body.


func _on_Retry_Game_pressed():
	player_data.weapon_selected = weapon_displayed
	gamemanager.set_player_data(player_data)
	gamemanager.save_game()
	get_tree().change_scene("res://Scenes/BaseScene.tscn")
	pass # Replace with function body.

func update_data():
	if player_data != null:
		gamemanager.set_player_data(player_data)
		gamemanager.save_game()

func render_data():
	HPDisplay.set_text("HP lvl " + (player_data.hp_current_level + 1) as String + "/" + (upgrader.player_hp_data.size()) as String)
	MoneyDisplay.set_text("Gold: " + player_data.money as String)
	NRGDisplay.set_text("NRG lvl " + (player_data.nrg_current_level + 1) as String + "/" + (upgrader.player_nrg_data.size()) as String)
	SPDDisplay.set_text("SPD lvl " + (player_data.spd_current_level + 1) as String + "/" + (upgrader.player_spd_data.size()) as String)
	ACCDisplay.set_text("ACC lvl " + (player_data.acc_current_level + 1) as String + "/" + (upgrader.player_acc_data.size()) as String)

	HPUpgrade.set_text(upgrader.player_hp_level_cost[player_data.hp_current_level + 1] as String + "g")
	NRGUpgrade.set_text(upgrader.player_nrg_level_cost[player_data.nrg_current_level + 1] as String + "g")
	SPDUpgrade.set_text(upgrader.player_spd_level_cost[player_data.spd_current_level + 1] as String + "g")
	ACCUpgrade.set_text(upgrader.player_acc_level_cost[player_data.acc_current_level + 1] as String + "g")

	

	var weapon_name
	var weapon_level
	var weapon_max_level
	var level_cost
	match weapon_displayed as int:
		0:
			weapon_name = "Shells"
			weapon_level = player_data.shells_current_level
			weapon_max_level = upgrader.shells_level_cost.size()
			level_cost = upgrader.shells_level_cost[player_data.shells_current_level + 1]
		1:
			weapon_name = "Minigun"
			weapon_level = player_data.minigun_current_level
			weapon_max_level = upgrader.minigun_level_cost.size()
			level_cost = upgrader.minigun_level_cost[player_data.minigun_current_level + 1]
		2:
			weapon_name = "Spiked"
			weapon_level = player_data.spiked_current_level
			weapon_max_level = upgrader.spiked_level_cost.size()
			level_cost = upgrader.spiked_level_cost[player_data.spiked_current_level + 1]
		3:
			weapon_name = "Laser"
			weapon_level = player_data.laser_current_level
			weapon_max_level = upgrader.laser_level_cost.size()
			level_cost = upgrader.laser_level_cost[player_data.laser_current_level + 1]
	WeaponDisplay.set_text("Weapon: " + weapon_name + " lvl " + (weapon_level + 1) as String + "/" + weapon_max_level as String)
	WeaponUpgrade.set_text("Upgrade: " + level_cost as String + "g")
	
	pass

func _on_HPUpgrade_pressed():
	var cost = upgrader.player_hp_level_cost[player_data.hp_current_level + 1]
	if player_data.money - cost >= 0:
		player_data.money -= cost
		player_data.hp_current_level += 1
		update_data()
		render_data()
	
	pass # Replace with function body.


func _on_SPDUpgrade_pressed():
	var cost = upgrader.player_spd_level_cost[player_data.spd_current_level + 1]
	if player_data.money - cost >= 0:
		player_data.money -= cost
		player_data.spd_current_level += 1
		update_data()
		render_data()


func _on_NRGUpgrade_pressed():
	var cost = upgrader.player_nrg_level_cost[player_data.nrg_current_level + 1]
	if player_data.money - cost >= 0:
		player_data.money -= cost
		player_data.nrg_current_level += 1
		update_data()
		render_data()


func _on_PrevWeapon_pressed():
	if player_data.weapons_unlocked.size() > 1:
		if weapon_displayed == 0:
			weapon_displayed = player_data.weapons_unlocked.size() - 1
		elif weapon_displayed > 0:
			weapon_displayed -= 1
	render_data()

func _on_UpgradeWeapon_pressed():
	
	var cost
	var weapon
	match weapon_displayed as int:
		0:
			cost = upgrader.shells_level_cost[player_data.shells_current_level + 1]
			weapon = "shells_current_level"
		1:
			cost = upgrader.minigun_level_cost[player_data.minigun_current_level + 1]
			weapon = "minigun_current_level"
		2:
			cost = upgrader.spiked_level_cost[player_data.spiked_current_level + 1]
			weapon = "spiked_current_level"
		3:
			cost = upgrader.laser_level_cost[player_data.laser_current_level + 1]
			weapon = "laser_current_level"
			
	if player_data.money - cost >= 0:
		player_data.money -= cost
		player_data[weapon] += 1
		update_data()
		render_data()
	pass # Replace with function body.


func _on_NextWeapon_pressed():
	if player_data.weapons_unlocked.size() > 1:
		if weapon_displayed == player_data.weapons_unlocked.size() - 1:
			weapon_displayed = 0
		else:
			weapon_displayed += 1
	render_data()
