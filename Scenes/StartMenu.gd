extends Control

onready var gamemanager = $Gamemanager
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hello_btutton_pressed():
	get_tree().change_scene("res://Scenes/BaseScene.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func pressed():
	gamemanager.load_save()
	print(gamemanager.data)
	pass # Replace with function body.


func _on_Get_data_pressed():
	gamemanager.load_save()
	pass # Replace with function body.


func _on_Get_data2_pressed():
	gamemanager.load_save()
	gamemanager.data.player.accuracylvl += 1
	gamemanager.save_game()
	pass # Replace with function body.


func _on_Reset_Game_pressed():
	gamemanager.reset_data()
	gamemanager.save_game()
	pass # Replace with function body.


func _on_TankUpgrades_pressed():
	get_tree().change_scene("res://Scenes/UpgradeScene.tscn")
	pass # Replace with function body.
