extends KinematicBody2D

const MOVE_SPEED = 200
var HEALTH_POINTS = 10
onready var raycast = $RayCast2D

var player = null

func _ready():
	add_to_group("zombies")

func _physics_process(delta):
	if player == null:
		return
	$health.text = str(HEALTH_POINTS)
	if HEALTH_POINTS == 0:
		kill()
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			coll.take_damage(1)

func take_damage(DAMAGE):
		HEALTH_POINTS -= DAMAGE

func kill():
	queue_free()

func set_player(p):
	player = p
