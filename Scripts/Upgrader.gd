extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Lets say first area should take 3-4 runs
# So for first levels every run 3 upgrades
# From then 1.5-2 upgrades per run
# Area 1 is about 3-4 runs so 9-12 upgrades should be just strong enough for the start
# of area 2
# 20 upgrades should be enough to get to area 3 (4 runs so 6-8 upgrades)
# 28 upgrades should be enough to get to end (or boss if thats implemented)

# Maxed ~32 Upgrades

# stats acc, hp, spd, nrg, dmg
# 6-8 upgrades

# player should put some in nrg to have enough damage and time to actually kill the enemies
# should be able to get to the enemies with 2 points in nrg

# Player rewards to find how expensive rewards should be


# Lets say 8 upgrades
export var player_hp_current_level = 0
var player_hp_data = [100, 160, 240, 300, 360, 440, 500, 560, 620]
var player_hp_level_cost = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]

# Lets say 5 upgrades 
export var player_acc_current_level = 0
var player_acc_data = [25, 20, 15, 10, 5, 0] #randomness in degrees
var player_acc_level_cost = [0, 200, 850, 2200, 5000, 12800]

# Lets say 5 upgrades
export var player_spd_current_level = 0
var player_spd_data = [150, 240, 320, 390, 450, 490] # diminishing: 90 -> 80 -> 70 -> 60
var player_spd_level_cost = [0, 200, 850, 2200, 5000, 12800]

# Lets say 8 upgrades
# its a mix of movement and being able to deal damage
export var player_nrg_current_level = 0
var player_nrg_data = [100, 200, 300, 400, 500, 600, 700, 800, 900]
var player_nrg_level_cost = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]

#
enum player_weapons {
	shells = 0,
	minigun = 1,
	spikes = 2,
	laser = 3,
}



export var player_weapon_selected = 0
export var player_weapons_unlocked = [0]

# Lets say 9 upgrades
var shells_dps = [10, 20, 40, 80, 160,
 320, 640, 1280, 2560, 5120]
export var shells_current_level = 0
var shells_level_cost = [0, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800]

# Lets say 6 upgrades
var minigun_dps = [80, 160,
 320, 640, 1280, 2560, 5120]
export var minigun_current_level = 0
var minigun_level_cost = [0, 200, 400, 800, 1600, 3200, 6400, 12800]


# Lets say 4 upgrades
var spiked_dps = [320, 640, 1280, 2560, 5120]
export var spiked_current_level = 0
var spiked_level_cost = [0, 800, 1600, 3200, 6400, 12800]



# Lets say 2 upgrades
var laser_dps = [1280, 2560, 5120]
export var laser_current_level = 0
var laser_level_cost = [0, 3200, 6400, 12800]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_unlocked_weapons():
	return player_weapons_unlocked

func add_unlocked_weapon(number):
	player_weapons_unlocked.insert(player_weapons_unlocked.size(), number)
