extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var money = 0
onready var moneyDisplay := $MoneyDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	moneyDisplay.set_text(money as String)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_money(money)
		queue_free()
	pass # Replace with function body.

func set_money(val):
	money = val
