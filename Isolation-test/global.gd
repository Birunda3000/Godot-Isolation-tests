extends Node
var PRESENT_WEAPON = "pistol"

func _physics_process(_delta):
	if Input.is_action_just_pressed("pistol"):
		PRESENT_WEAPON = "pistol"
		
	if Input.is_action_just_pressed("machinegun"):
		PRESENT_WEAPON = "machinegun"
