extends Node

var _transition_active = false
var _next_floor_number = 0

func set_transition_active(active: bool):
	_transition_active = active

func is_transition_active() -> bool:
	return _transition_active

func set_next_floor_number(floor_num: int):
	_next_floor_number = floor_num

func get_next_floor_number() -> int:
	return _next_floor_number

func reset():
	_transition_active = false
	_next_floor_number = 0
