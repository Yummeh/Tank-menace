extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1200
export var damage = 10
var velocity = Vector2()
var HitParticle = preload("res://Objects/HitParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_timer()
	
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
		print(collision.collider.get_class())
		if collision.collider.is_in_group("Enemy"):
			collision.collider.remove_health(damage)
			var tree = get_tree().get_root()
			var hitInstance = HitParticle.instance()
			hitInstance.set_position(global_position)
			tree.add_child(hitInstance)
				
#	position += velocity * delta

func set_timer():
	var timer = Timer.new()
	self.add_child(timer)
		
	# Connect the timer to make it call "queue_free" after two seconds
	timer.connect("timeout", self, "queue_free")
	timer.set_wait_time(2)
	timer.start()	

func set_velocity_direction(direction):
	velocity = direction.normalized() * speed

func _on_Area2D_body_entered(body):
	var layer = body.get_collision_layer()
	if layer == 5:
		body.remove_health(damage)
		print(body.name)
	
#	if body
	pass # Replace with function body.

func set_damage(points):
	damage = points

func explode():
	pass
#	var shell_instance = shell_node.instance()
#	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
#
#	shell_instance.set_position(player.position + mouse_dir * 70)
#	shell_instance.set_rotation(mouse_dir.angle())
#	shell_instance.set_velocity_direction(mouse_dir)
#	shell_instance.set_damage(player.damage)
#
#	tree.add_child(shell_instance)
