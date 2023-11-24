extends Area2D

signal turned

@export var speed = 100
@export var turn_speed = 3

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
		
		rotation += turn_speed * turn * delta
