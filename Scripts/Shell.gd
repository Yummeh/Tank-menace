extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1200
export var damage = 10
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_timer()
	
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

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
	queue_free()
	
#	if body
	pass # Replace with function body.

func set_damage(points):
	damage = points
