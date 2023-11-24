extends Node

const Player = preload("res://player.tscn")

var scores = [0,0,0,0]

func _process(delta):
	var alive
	for player in $Players.get_children():
		if player.alive:
			if alive == null:
				alive = player
			else:
				return
	if alive != null:
		if $RestartTimer.is_stopped():
			$RestartTimer.start()
			scores[alive.player_num-1] += 1
			get_node("ScoreP"+str(alive.player_num)).text = "P"+str(alive.player_num)+": "+str(scores[alive.player_num-1])
			print(scores)
		


func _on_restart_timer_timeout():
	print("hey")
	var num_players = $Players.get_child_count()
	
	for player in $Players.get_children():
		player.queue_free()
	
	for i in num_players:
		var new_pl = Player.instantiate()
		new_pl.player_num = i+1
		$Players.add_child(new_pl)
