extends Area2D

signal turned
signal outside

var speed = 100
var turn_speed = 3

var alive = true
var player = 1


func _process(delta):
	if alive:
		position += speed * Vector2.UP.rotated(rotation) * delta
			
		var turn = 0
		if Input.is_action_pressed("turn_right_p"+str(player)):
			turn += 1
		if Input.is_action_pressed("turn_left_p"+str(player)):
			turn -= 1
			
		if turn != 0:
			emit_signal("turned")
			
		if global_position[0] < 62 or global_position[0] > 1538:
			emit_signal("outside")
		if global_position[1] < 62 or global_position[1] > 1538:
			emit_signal("outside")
		
		rotation += turn_speed * turn * delta
