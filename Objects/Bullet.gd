extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 5
var speed = 1300

var velocity = Vector2()

var HitParticle = preload("res://Objects/HitParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position += velocity * delta
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_velocity_direction(direction):
	velocity = direction.normalized() * speed

func _on_Node2D_body_entered(body):
	
	if body.is_in_group("Enemy"):
		print(damage)
		body.remove_health(damage)
		var tree = get_tree().get_root()
		var hitInstance = HitParticle.instance()
		hitInstance.set_position(global_position)
		tree.add_child(hitInstance)
		hitInstance.setHitParticleValue(damage)
		
	queue_free()
	
	pass # Replace with function body.

func set_damage(points):
	damage = points
