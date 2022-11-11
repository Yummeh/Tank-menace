extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var weapon_upgrade_id = 0
export var show_at_all_times = false
var upgrader
var gamemanager

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrader = get_tree().get_root().get_node("Root/Upgrader")
	gamemanager = get_tree().get_root().get_node("Root/Gamemanager")
	if upgrader == null || gamemanager == null:
		print("WeaponUpgrade.gd: Upgrader node not found")
	
	if gamemanager != null:
		if gamemanager.data.weapons_unlocked.has(weapon_upgrade_id as float) && !show_at_all_times:
			queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WeaponUpgrade_body_entered(body):
	if body.name == "Player":
		if upgrader != null && gamemanager != null:
			print(gamemanager.data.weapons_unlocked)
			print(gamemanager.data.weapons_unlocked.has(weapon_upgrade_id as float))
			if !gamemanager.data.weapons_unlocked.has(weapon_upgrade_id as float):
				gamemanager.data.weapons_unlocked.insert(gamemanager.data.weapons_unlocked.size(), weapon_upgrade_id)
				print("insert")
				
		if weapon_upgrade_id == 3:
			pass
		
		hide()
#		queue_free()
	pass # Replace with function body.

