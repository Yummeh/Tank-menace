extends Node

var path = "user://data.json"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var default_data = {
		"money": 0,
		"hp_current_level": 0,
		"spd_current_level": 0,
		"acc_current_level": 0,
		"nrg_current_level": 0,
		"weapons_unlocked": [0],
		"shells_current_level": 0,
		"minigun_current_level": 0,
		"spiked_current_level": 0,
		"laser_current_level": 0,
}

var player_data = {
		"money": 0,
		"hp_current_level": 0,
		"spd_current_level": 0,
		"nrg_current_level": 0,
		"acc_current_level": 0,
		"weapons_unlocked": [0],
		"shells_current_level": 0,
		"minigun_current_level": 0,
		"spiked_current_level": 0,
		"laser_current_level": 0,
}

export var player_hp_current_level = 0
export var player_acc_current_level = 0
export var player_spd_current_level = 0
export var player_nrg_current_level = 0
export var player_gun_selected = 0
export var player_weapons_unlocked = [0]
export var shells_current_level = 0
export var minigun_current_level = 0

var data = { }
var player

# Called when the node enters the scene tree for the first time.
func _ready():
#	player = get_tree().get_root().get_node("Root/Player")
	# Start UI scene
	# When player clicks start load level scene
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_save():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
		
	file.open(path, file.READ)
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()

	
func save_game():
	var file
	file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(data))
	file.close()

func reset_data():
	data = default_data.duplicate(true)
	
func set_player_data(p_data):
	data = p_data
	
func get_data():
	pass

func _on_Get_data_pressed():
	pass # Replace with function body.


func _on_Some_pressed():
	pass # Replace with function body.
