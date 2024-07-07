extends CardDisplayer
class_name GridCardDisplayer

@export_range (1,20) var max_cols = 5
@export_range (1,20) var max_rows = 3
@export var expand:bool

func reorder_cards():
	var count = cards.size()
	if count > max_cols*max_rows:
		printerr("Too many cards to display for current grid displayer")
	
	@warning_ignore("integer_division")
	var needed_rows = (count-1) / max_cols + 1
	var spacing_x = rect.size.x / max_cols
	var spacing_y = rect.size.y / needed_rows
	var begin_x = rect.size.x / 2 - card_width / 2
	var begin_y = rect.size.y / 2 - card_height / 2
	var curr_row = 0
	var curr_col = 0
	
	for card in cards:
		card.position = Vector2(curr_col * spacing_x - begin_x, curr_row * spacing_y - begin_y)
		card.rotation = 0
		if curr_col == (max_cols - 1):
			curr_col = 0
			curr_row = curr_row + 1
		else:
			curr_col = curr_col + 1
	  
