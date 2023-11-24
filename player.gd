extends Node

@export var player_num = 1
@export var immunity_segments = 4

var can_split = true
var following = true
var alive = true

const Tail = preload("res://tail.tscn")
const StaticTail = preload("res://static_tail.tscn")

func _ready():
	$Head.set_collision_mask_value(player_num, true)
	$Head.player = player_num
	for i in range(1,5):
		if i == player_num:
			continue
		$Tail.set_collision_layer_value(i, true)
	
	if player_num == 2: 
		$Head/Polygon2D.color = Color.SKY_BLUE
		$BridgeLine2D.default_color = Color.SKY_BLUE
		$Tail/Line2D.default_color = Color.SKY_BLUE
		$StaticTail/Line2D.default_color = Color.SKY_BLUE  


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


func _on_head_area_entered(area):
	$Head/Polygon2D.color = Color.RED
	$Head.alive = false
	$Head.move_to_front()
	alive = false

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
	
	
	if player_num == 2: 
		$Tail/Line2D.default_color = Color.SKY_BLUE
		$StaticTail/Line2D.default_color = Color.SKY_BLUE  
	
	
	$Tail.following = true
	following = true
	$GapStartTimer.start()
