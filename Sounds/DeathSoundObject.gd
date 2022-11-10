extends Node2D

onready var deathAudio := $DeathSound
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var doAudio = true
# Called when the node enters the scene tree for the first time.
func _ready():
	deathAudio.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_DeathSound_finished():
	queue_free()
	pass # Replace with function body.
