extends KinematicBody2D
export ( PackedScene ) var bala

#preload de texturas
var holding_pistol_texture = load("res://textures/Top_Down_Survivor/handgun/idle/survivor-idle_handgun_0.png") 
var holding_machinegun_texture = load("res://textures/Top_Down_Survivor/rifle/idle/survivor-idle_rifle_0.png")


onready var sprite = $Sprite
var MOVE_SPEED = 300
var HEALTH_POINTS = 10

#timer parar tomar dano novamente após dano tomado
var invul_timer = null
var invul_time = 1
var can_take_damage = true

#timer para atirar machinegun
var mg_timer = null
var delay_bala_mg = 0.1
var can_shoot_mg = true

#timer para atirar com a pistola
var ps_timer = null
var delay_bala_ps = 0.25
var can_shoot_ps = true



func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	
	#configuração do timer para invulnerabilidade após dano
	invul_timer = Timer.new()
	invul_timer.set_one_shot(true)
	invul_timer.set_wait_time(invul_time)
	invul_timer.connect("timeout",self,"on_invul_complete")
	add_child(invul_timer)
	
	#configuração do timer para tiro de machinegun
	mg_timer = Timer.new()
	mg_timer.set_one_shot(true)
	mg_timer.set_wait_time(delay_bala_mg)
	mg_timer.connect("timeout",self,"on_timeout_complete_mg")
	add_child(mg_timer)
	
	#configuração do timer para tiro de pistola
	ps_timer = Timer.new()
	ps_timer.set_one_shot(true)
	ps_timer.set_wait_time(delay_bala_ps)
	ps_timer.connect("timeout",self,"on_timeout_complete_ps")
	add_child(ps_timer)
	
func on_timeout_complete_mg():
	can_shoot_mg = true
	
func on_timeout_complete_ps():
	can_shoot_ps = true
	
func on_invul_complete():
	can_take_damage = true

func _physics_process(delta):
	#movimentação do personagem
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("run"):
		MOVE_SPEED = 500
	if Input.is_action_just_released("run"):
		MOVE_SPEED = 300
	#ajustando posição dos colisores baseado na arma
	if Global.PRESENT_WEAPON == "pistol" :
		sprite.texture = holding_pistol_texture
		$weapon.position.x = $CollisionShape2D.position.x + 72.624 
		$weapon.position.y = $CollisionShape2D.position.y + 24.922 
	if Global.PRESENT_WEAPON == "machinegun" :
		sprite.texture = holding_machinegun_texture
		$weapon.position.x = $CollisionShape2D.position.x + 92.07 
		$weapon.position.y = $CollisionShape2D.position.y + 22.541 
		
	if HEALTH_POINTS == 0:
		kill()
		
	#textos com nome da arma e vida do personagem
	get_node("CanvasLayer/weapon").text = Global.PRESENT_WEAPON
	get_node("CanvasLayer/health").text = str(HEALTH_POINTS)
	
	#calcula da velocidade do movimento
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	#rotação da camera
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	#inputs para disparos
	if Input.is_action_just_pressed("shoot") and Global.PRESENT_WEAPON == "pistol" and can_shoot_ps:
		shoot()
		can_shoot_ps = false
		ps_timer.start()
		
	if Input.is_action_pressed("shoot") and Global.PRESENT_WEAPON == "machinegun" and can_shoot_mg:
		shoot()
		can_shoot_mg = false
		mg_timer.start()
		
		
#Função para tirar dano do personagem		
func take_damage(DAMAGE):
	if can_take_damage:
		HEALTH_POINTS -= DAMAGE
		can_take_damage = false
		invul_timer.start()
			
#morte do personagem		
func kill():
	get_tree().reload_current_scene()

#função para instanciar balas
func shoot():
	var b = bala.instance()
	owner.add_child(b)
	b.transform = $weapon.global_transform
	

