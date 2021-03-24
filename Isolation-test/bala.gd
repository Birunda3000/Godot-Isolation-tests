extends Area2D

var speed = 1000
var weapon = "pistol"

func _ready():
	connect("body_entered", self, "_on_bala_body_entered")
	
func _physics_process(delta):
	position += transform.x * speed * delta
	
	
func _on_bala_body_entered(body):
	if body.is_in_group("zombies"):
		if  Global.PRESENT_WEAPON == "pistol":
			body.take_damage(2)
			queue_free()
		elif Global.PRESENT_WEAPON == "machinegun":
			body.take_damage(1)
			queue_free()
