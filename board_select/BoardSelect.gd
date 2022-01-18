extends VBoxContainer

func _ready():
	$SizeOption.add_item("8 x 8", Global.BoardSize.EIGHT_EIGHT)
	$SizeOption.add_item("16 x 16", Global.BoardSize.SIXTEEN_SIXTEEN)
	$SizeOption.add_item("32 x 16", Global.BoardSize.THIRTYTWO_SIXTEEN)
	$SizeOption.select(Global.BoardSize.EIGHT_EIGHT)
	
	$DifficultyOption.add_item("Easy", Global.Difficulty.EASY)
	$DifficultyOption.add_item("Medium", Global.Difficulty.MEDIUM)
	$DifficultyOption.add_item("Hard", Global.Difficulty.HARD)
	$DifficultyOption.select(Global.Difficulty.EASY)


func _on_StartButton_pressed():
	Global.current_difficulty = $DifficultyOption.selected
	match $SizeOption.selected:
		Global.BoardSize.EIGHT_EIGHT:
			Global.current_x = 8
			Global.current_y = 8
		Global.BoardSize.SIXTEEN_SIXTEEN:
			Global.current_x = 16
			Global.current_y = 16
		Global.BoardSize.THIRTYTWO_SIXTEEN:
			Global.current_x = 32
			Global.current_y = 16
		_:
			Global.current_x = 0
			Global.current_y = 0
	get_tree().change_scene("res://game/Game.tscn")
