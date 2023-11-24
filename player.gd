extends Node

@export var player_num = 1
@export var immunity_segments = 4
@export var speed = 150
@export var turn_speed = 3
@export var gap_time = 0.4

var can_split = true
var following = false
var alive = true

var player_colors = [
	Color(253/255.0, 246/255.0, 227/255.0), # Base3 white
	Color(38/255.0, 139/255.0, 210/255.0), # Blue
	Color(133/255.0, 153/255.0, 0/255.0), # Green
	Color(42/255.0, 161/255.0, 152/255.0), # Cyan
	]
var player_color = Color()

const Tail = preload("res://tail.tscn")
const StaticTail = preload("res://static_tail.tscn")

func _ready():
	player_color = player_colors[player_num-1]
	print(player_num)
	print(player_color)
	$Head.player = player_num
	$Head.speed = 0
	$Head.turn_speed = turn_speed
	$Head.rotation = randf()*PI
	$Head.position += 20*Vector2.UP.rotated($Head.rotation)
	$GapEndTimer.wait_time = gap_time
	for i in range(1,5):
		if i == player_num:
			continue
		$Tail.set_collision_layer_value(i, true)
	
	$Head/Polygon2D.color = player_color
	$BridgeLine2D.default_color = player_color
	$Tail/Line2D.default_color = player_color
	$StaticTail/Line2D.default_color = player_color
	


func _process(delta):
	if following:
		$Tail.get_node("Line2D").points[-1] = $Head.position

		if $StaticTail/Line2D.points.size() > 1:
			$BridgeLine2D.points[2] = $StaticTail/Line2D.points[-2]
			#$BridgeLine2D.points[2] = $StaticTail/Line2D.points[-1]
			$BridgeLine2D.points[1] = $Tail/Line2D.points[0]
			$BridgeLine2D.points[0] = $Tail/Line2D.points[1]
	
	
func _on_head_turned():
	if not alive:
		return
	if following and can_split:
		$Tail.split()
		
		if $Tail/Line2D.points.size() > immunity_segments:
			$StaticTail.transfer($Tail)
			$Tail.transfer()
			
		$SplitTimer.start()
		can_split = false

func die():
	$Head/Polygon2D.color = Color(220/255.0, 50/255.0, 47/255.0)
	$Head.alive = false
	$Head.move_to_front()
	alive = false
	
func _on_head_area_entered(area):
	die()

func _on_split_timer_timeout():
	can_split = true


func _on_gap_start_timer_timeout():
	if not alive:
		return
		
	$Tail.following = false
	following = false
	$GapEndTimer.start()


func _on_gap_end_timer_timeout():
	if not alive:
		return

	while $Tail/Line2D.points.size() > 1:
		$StaticTail.transfer($Tail)
		$Tail.transfer()
	
	$StaticTail.reparent($OldTails)
	var new_static_tail = StaticTail.instantiate()
	new_static_tail.set_name("StaticTail")
	new_static_tail.get_node("Line2D").points[0] = $Head.position
	add_child(new_static_tail)
	
	
	var new_tail = Tail.instantiate()
	new_tail.set_name("Tail")
	new_tail.get_node("Line2D").points[0] = $Head.position
	new_tail.get_node("Line2D").points[1] = $Head.position
	new_tail.sync_current_collision_body()
	$Tail.free()
	for i in range(1,5):
		if i == player_num:
			continue
		new_tail.set_collision_layer_value(i, true)
	add_child(new_tail)
	
	
	$Tail/Line2D.default_color = player_color
	$StaticTail/Line2D.default_color = player_color
	
	
	$Tail.following = true
	following = true
	$GapStartTimer.start(randf_range(1,6))

func _on_start_tail_timer_timeout():
	$GapStartTimer.start(randf_range(1,6)) 
	following = true
	$Tail.following = true
	$Tail/Line2D.points[0] = $Head.position
	$Tail/Line2D.points[1] = $Head.position
	$StaticTail/Line2D.points[0] = $Head.position
	$Head.set_collision_mask_value(player_num, true)


func _on_start_moving_timer_timeout():
	$Head.speed = speed
