extends GridContainer

signal game_lost
signal game_won
signal set_flag
signal unset_flag

const Mine: PackedScene = preload("res://mine_button/MineButton.tscn")

var x: int
var y: int
var num_safe_remaining: int
var num_mines: int

func total_mines() -> int:
	return num_mines

func _mine_proportion(difficulty: int) -> float:
	match difficulty:
		Global.Difficulty.EASY:
			return 0.15
		Global.Difficulty.MEDIUM:
			return 0.20
		Global.Difficulty.HARD:
			return 0.25
		_:
			return 0.0
			
func _get_offsets(index: int) -> PoolIntArray:
	var offsets = PoolIntArray()
	var is_top_row = index < x
	var is_bottom_row = index >= (x * y-1)
	var is_left_side = index % x == 0
	var is_right_side = (index + 1) % x == 0
	
	if not is_top_row:
		offsets.append(index - x)
		if not is_left_side:
			offsets.append(index - x - 1)
		if not is_right_side:
			offsets.append(index - x + 1)
	if not is_bottom_row:
		offsets.append(index + x)
		if not is_left_side:
			offsets.append(index + x - 1)
		if not is_right_side:
			offsets.append(index + x + 1)
	if not is_left_side:
		offsets.append(index - 1)
	if not is_right_side:
		offsets.append(index + 1)
		
	var size = x * y
	for i in range(offsets.size() - 1, -1, -1):
		if offsets[i] < 0 or offsets[i] >= size:
			offsets.remove(i)
	
	return offsets
	

func init(_x: int, _y: int, difficulty: int) -> void:
	randomize()
	x = _x
	y = _y
	columns = x
	var length: int = x*y
	var mines: Array = []
	mines.resize(length)
	num_mines = ceil(length * _mine_proportion(difficulty))
	num_safe_remaining = length - num_mines
	
	# First create array of ints indicating if has a mine or not
	for i in range(num_safe_remaining):
		mines[i] = 0
	for i in range(num_safe_remaining, length):
		mines[i] = 1
	
	# Shuffle the mines around
	mines.shuffle()
	
	# Now create actual mine objects + append
	for i in range(length):
		var has_bomb = mines[i] == 1
		var adjacent = 0
		for other in _get_offsets(i):
			adjacent += mines[other]
		var mine = Mine.instance()
		mine.init(has_bomb, adjacent)
		mine.connect("exploded", self, "lost")
		mine.connect("exposed", self, "exposed_empty")
		mine.connect("set_flag", self, "set_flag")
		mine.connect("unset_flag", self, "unset_flag")
		
		add_child(mine)
		
func set_flag() -> void:
	emit_signal("set_flag")
	
func unset_flag() -> void:
	emit_signal("unset_flag")
		
func lost() -> void:
	emit_signal("game_lost")
	
func exposed_empty(index: int) -> void:
	var child = get_child(index)
	num_safe_remaining -= 1
	if num_safe_remaining == 0:
		emit_signal("game_won")
	elif child.adjacent_count == 0:
		for other in _get_offsets(index):
			var other_child = get_child(other)
			if not other_child.has_bomb:
				other_child.reveal()

