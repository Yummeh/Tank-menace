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


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_data

# Called when the node enters the scene tree for the first time.
func _ready():
	gamemanager.load_save()
	player_data = gamemanager.data
	render_data()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Retry_Game_pressed():
	get_tree().change_scene("res://Scenes/BaseScene.tscn")
	pass # Replace with function body.

func update_data():
	if player_data != null:
		gamemanager.set_player_data(player_data)
		gamemanager.save_game()

func render_data():
	HPDisplay.set_text("HP lvl " + (player_data.hp_current_level + 1) as String + "/" + (upgrader.player_hp_data.size()) as String)
	MoneyDisplay.set_text("Money: " + player_data.money as String)
	NRGDisplay.set_text("NRG lvl " + (player_data.nrg_current_level + 1) as String + "/" + (upgrader.player_nrg_data.size()) as String)
	SPDDisplay.set_text("SPD lvl " + (player_data.spd_current_level + 1) as String + "/" + (upgrader.player_spd_data.size()) as String)
	ACCDisplay.set_text("ACC lvl " + (player_data.acc_current_level + 1) as String + "/" + (upgrader.player_acc_data.size()) as String)

	HPUpgrade.set_text(upgrader.player_hp_level_cost[player_data.hp_current_level + 1] as String + "g")
	NRGUpgrade.set_text(upgrader.player_nrg_level_cost[player_data.nrg_current_level + 1] as String + "g")
	SPDUpgrade.set_text(upgrader.player_spd_level_cost[player_data.spd_current_level + 1] as String + "g")
	ACCUpgrade.set_text(upgrader.player_acc_level_cost[player_data.acc_current_level + 1] as String + "g")

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
