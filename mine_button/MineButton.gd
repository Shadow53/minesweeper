extends TextureButton

signal exploded
signal exposed(index)
signal set_flag
signal unset_flag

const HOLD_DELAY_MSEC: int = 400

const FLAGGED_SPRITE: Texture = preload("res://mine_button/sprites/flag_button.png")
const FLAGGED_SPRITE_PRESSED: Texture = preload("res://mine_button/sprites/flag_button_pressed.png")
const NORMAL_SPRITE: Texture = preload("res://mine_button/sprites/blank_button.png")
const NORMAL_SPRITE_PRESSED: Texture = preload("res://mine_button/sprites/blank_button_pressed.png")

var press_timestamp: int = -1
var has_bomb: bool = false
var adjacent_count: int = 0

func init(_has_bomb: bool, _adjacent_count: int):
	has_bomb = _has_bomb
	adjacent_count = _adjacent_count
	if _adjacent_count > 0:
		texture_disabled = load("res://mine_button/sprites/pressed_" + str(adjacent_count) + ".png")

func explode():
	$BombExplosion.visible = true
	$BombExplosion.playing = true

func set_flag() -> void:
	texture_normal = FLAGGED_SPRITE
	texture_pressed = FLAGGED_SPRITE_PRESSED
	texture_hover = FLAGGED_SPRITE_PRESSED
	texture_focused = FLAGGED_SPRITE_PRESSED
	emit_signal("set_flag")

func unset_flag() -> void:
	texture_normal = NORMAL_SPRITE
	texture_pressed = NORMAL_SPRITE_PRESSED
	texture_hover = NORMAL_SPRITE_PRESSED
	texture_focused = NORMAL_SPRITE_PRESSED
	emit_signal("unset_flag")
	
func toggle_flag() -> void:
	if texture_normal == NORMAL_SPRITE:
		set_flag()
	else:
		unset_flag()
	
func reveal() -> void:
	if not disabled:
		if texture_normal == FLAGGED_SPRITE:
			emit_signal("unset_flag")
		set_disabled(true)
		if has_bomb:
			explode()
			yield($BombExplosion, "animation_finished")
			emit_signal("exploded")
		else:
			# Work around the disabled texture not being prioritized
			texture_focused = texture_disabled
			texture_hover = texture_disabled
			texture_pressed = texture_disabled
			texture_normal = texture_disabled
			emit_signal("exposed", get_index())

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and not disabled:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				press_timestamp = OS.get_ticks_msec()
			else:
				if OS.get_ticks_msec() - press_timestamp >= HOLD_DELAY_MSEC:
					toggle_flag()
				else:
					reveal()
		elif event.button_index == BUTTON_RIGHT and not event.pressed:
			toggle_flag()
