extends Node

const DefaultTheme: Theme = preload("res://global_theme.tres")

enum Difficulty { EASY, MEDIUM, HARD }
enum BoardSize { EIGHT_EIGHT, SIXTEEN_SIXTEEN, THIRTYTWO_SIXTEEN }

var current_difficulty: int = -1
var current_x: int = -1
var current_y: int = -1

func quit() -> void:
	get_tree().quit()
