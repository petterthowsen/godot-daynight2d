extends KinematicBody2D


var speed:float = 64


func _physics_process(delta):
	var move = Vector2()
	
	if Input.is_key_pressed(KEY_W):
		move.y = -1
	if Input.is_key_pressed(KEY_S):
		move.y = 1
	if Input.is_key_pressed(KEY_A):
		move.x = -1
	if Input.is_key_pressed(KEY_D):
		move.x = 1
	
	move = move.normalized()
	
	move_and_collide(move * speed * delta)
