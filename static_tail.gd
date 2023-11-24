extends Area2D


func transfer(tail):
	$Line2D.add_point(tail.get_node("Line2D").points[1])
	var length = $Line2D.points[-2].distance_to($Line2D.points[-1])
	if length < 0.001:
		return
	var new_shape = CollisionShape2D.new()
	new_shape.position = tail.get_child(1).position
	new_shape.rotation = tail.get_child(1).rotation
	var rect = RectangleShape2D.new()
	rect.extents = tail.get_child(1).shape.extents
	new_shape.shape = rect
	add_child(new_shape)
