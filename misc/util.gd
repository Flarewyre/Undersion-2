class_name general_util

static func move_towards(value, goal, increment):
	if value > goal:
		value -= increment;
		if value < goal:
			value = goal;

	if value < goal:
		value += increment;
		if value > goal:
			value = goal;

	return value
