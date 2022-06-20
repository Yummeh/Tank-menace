extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var weapon_upgrade_id = 0
var upgrader

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	if upgrader == null:
		print("WeaponUpgrade.gd: Upgrader node not found")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WeaponUpgrade_body_entered(body):
	if body.name == "Player" && !upgrader.get_unlocked_weapons().has(weapon_upgrade_id):
		if weapon_upgrade_id == 3:
			get_tree().change_scene("res://Scenes/BaseScene.tscn")
			
		upgrader.add_unlocked_weapon(weapon_upgrade_id)
		queue_free()
	pass # Replace with function body.

