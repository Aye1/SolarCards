extends CardDisplayer
class_name GridCardDisplayer

@export_range (1,20) var max_cols = 5
@export_range (1,20) var max_rows = 3
@export var horizontal_margin:int = 5
@export var vertical_margin:int = 5
@export_enum("Left", "Center", "Right") var horizontal_alignment: String = "Left" : set = _set_horizontal_alignment
@export_enum("Top", "Middle", "Bottom") var vertical_alignment: String = "Top" : set = _set_vertical_alignment

#TODO: not sure if Expanded is needed
@export_enum("Fixed", "Expanded") var card_spacing: String = "Fixed"

func reorder_cards():
	var count = cards.size()
	if count > max_cols * max_rows:
		printerr("Too many cards to display for current grid displayer")
	
	var spacing_x = _get_spacing_x()
	var spacing_y = _get_spacing_y()
	var begin_x = _get_begin_x(0)
	var begin_y = _get_begin_y()
	#var begin_y = rect.size.y / 2 - card_height / 2 - vertical_margin
	var curr_row = 0
	var curr_col = 0
	
	for card in cards:
		card.position = Vector2(curr_col * spacing_x - begin_x, curr_row * spacing_y - begin_y)
		card.rotation = 0
		if curr_col == (max_cols - 1):
			curr_col = 0
			curr_row = curr_row + 1
			begin_x = _get_begin_x(curr_row)
		else:
			curr_col = curr_col + 1
	
# Determines the horizontal starting position to put cards
# It's an offset from the grid center		
func _get_begin_x(current_row:int) -> float:
	var remaining_cards_count = cards.size() - current_row * max_cols
	var cards_on_row = min(remaining_cards_count, max_cols)
	match horizontal_alignment:
		"Left":
			return rect.size.x / 2 - card_width / 2 - horizontal_margin
		"Center":
			return (cards_on_row - 1) / 2.0 * (card_width + horizontal_margin)
		"Right":
			return (cards_on_row - 0.5) * (card_width + horizontal_margin) + horizontal_margin - rect.size.x / 2
		_:
			printerr("Unexpected alignment in GridCardDisplayer: " + horizontal_alignment)
			return 0.0
			
# Determines the vertical starting position to put cards
# It's an offset from the grid center		
func _get_begin_y() -> float:
	@warning_ignore("integer_division")
	var row_count = (cards.size() - 1) / max_cols + 1
	match vertical_alignment:
		"Top":
			return rect.size.y / 2 - card_height / 2 - vertical_margin
		"Middle":
			return (row_count - 1) / 2.0 * (card_height + vertical_margin)
		"Bottom":
			return (row_count - 0.5) * (card_height + vertical_margin) + horizontal_margin - rect.size.y / 2
		_:
			printerr("Unexpected alignment in GridCardDisplayer: " + vertical_alignment)
			return 0.0

func _get_spacing_x() -> float:
	match card_spacing:
		"Fixed":
			return card_width + horizontal_margin
		"Expanded":
			#TODO: is Expanded really needed? If so, maybe revisit that
			return rect.size.x / min(max_cols, cards.size())
		_:
			printerr("Unexpected spacing in GridCardDisplayer: " + card_spacing)
			return 0.0
			
func _get_spacing_y() -> float:
	match card_spacing:
		"Fixed":
			return card_height + vertical_margin
		"Expanded":
			@warning_ignore("integer_division")
			return rect.size.y / float(((cards.size()-1) / max_cols + 1))
		_:
			printerr("Unexpected spacing in GridCardDisplayer: " + card_spacing)
			return 0.0
			
func _set_horizontal_alignment(value):
	horizontal_alignment = value
	reorder_cards()
	
func _set_vertical_alignment(value):
	vertical_alignment = value
	reorder_cards()
	  
