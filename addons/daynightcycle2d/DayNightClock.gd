extends Node

const DateTime = preload("res://addons/daynightcycle2d/DateTime.gd")

signal time_passed(date_times)

export(int) var initial_year:int = 1
export(int, 1, 365) var initial_day:int = 0
export(int, 0, 23) var initial_hour:int = 6

var time:float = (60 * 60 * 24 * 365 * initial_year) + (initial_day * 60 * 60 * 24) + (60 * 60 * initial_hour)
export(float) var time_multiplier:float = 60 * 60 * 1

var dateTime:DateTime = DateTime.new(time)


func _process(delta):
	time += delta * time_multiplier
	dateTime = DateTime.new(time)
	
	emit_signal("time_passed", delta * time_multiplier)


func set_time(t: float):
	time = t
	dateTime = DateTime.new(time)
