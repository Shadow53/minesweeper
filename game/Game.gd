extends VBoxContainer

const MineField: PackedScene = preload("res://mine_field/MineField.tscn")

var flags_used: int = 0
	
func set_flags_used() -> void:
	$HUD/FlagsLabel.text = "Flags: " + str(flags_used) + "/" + str($MineFieldContainer.get_child(0).total_mines())

# Called when the node enters the scene tree for the first time.
func _ready():
	var mine_field = MineField.instance()
	mine_field.init(Global.current_x, Global.current_y, Global.current_difficulty)
	mine_field.connect("game_lost", self, "_on_MineField_game_lost")
	mine_field.connect("game_won", self, "_on_MineField_game_won")
	mine_field.connect("set_flag", self, "set_flag")
	mine_field.connect("unset_flag", self, "unset_flag")
	$HUD/MinesLabel.text = "Mines: " + str(mine_field.total_mines())
	$MineFieldContainer.add_child(mine_field)
	set_flags_used()
	
func set_flag() -> void:
	flags_used += 1
	set_flags_used()
	
func unset_flag() -> void:
	flags_used -= 1
	set_flags_used()

func _on_MineField_game_won():
	game_over("Congratulations!")

func _on_MineField_game_lost():
	game_over("Better luck next time...")

func game_over(message: String) -> void:
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = message + "\n\nWould you like to start a new game?"
	dialog.set_autowrap(true)
	dialog.set_exclusive(true)
	dialog.set_as_minsize()
	dialog.theme = Global.DefaultTheme
	dialog.connect("confirmed", self, "new_game")
	dialog.connect("canceled", Global, "quit")
	add_child(dialog)
	dialog.popup_centered()


func new_game() -> void:
	get_tree().change_scene("res://board_select/BoardSelect.tscn")
