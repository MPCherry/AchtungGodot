extends Area2D

var following = true

func sync_current_collision_body():
	var last_child = get_child(get_child_count()-1)
	last_child.position = ($Line2D.points[-2] + $Line2D.points[-1]) / 2
	last_child.rotation = $Line2D.points[-2].direction_to($Line2D.points[-1]).angle()
	var length = $Line2D.points[-2].distance_to($Line2D.points[-1])
	last_child.shape.extents = Vector2(length / 2, 10)

func _process(delta):
	if following:
		sync_current_collision_body()

func split():
		var length = $Line2D.points[-2].distance_to($Line2D.points[-1])
		if length > 0.001:
			$Line2D.add_point($Line2D.points[-1])
			var new_shape = CollisionShape2D.new()
			var rect = RectangleShape2D.new()
			new_shape.shape = rect 
			add_child(new_shape)

func transfer():
	$Line2D.remove_point(0)
	get_child(1).free()
