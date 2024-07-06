extends CardDisplayer
class_name Hand

const hand_padding = 50.0
const natural_hand_offset = 20.0
const card_max_rotation = PI / 12.0
const card_max_y_offset = 50.0
const card_hovered_y_offset = 50

func _process(delta):
	reorder_cards()
		
func reorder_cards():
	var count = cards.size()
	var offset = (count-1) * 0.5
	var spacing = card_width - _get_padding()
	
	var rot_count = count if count % 2 == 0 else count-1
	var rot_slope = 2/float(rot_count) if rot_count > 0 else 0.0
	var hand_size_ratio = minf(1.0, count/8.0) # we rotate less if we have less cards, with max at 8
	var curr = 0
	for card in cards:
		# As we always reorder cards, we don't want to move the currently dragged one until it's released
		if !card.draggable.is_dragged:			
			@warning_ignore("integer_division")
			var local_normalized_pos = (curr - count/2) / float(count)
			var localpos = Vector2((curr - offset) * spacing, abs(local_normalized_pos * hand_size_ratio * card_max_y_offset))
			card.position = localpos
			card.rotation = (rot_slope * curr - 1) * card_max_rotation * hand_size_ratio if count > 1 else 0.0
			if card.is_hovered():
				card.position.y = card.position.y - card_hovered_y_offset
				card.rotation = 0.0
		curr = curr + 1
		
func _get_padding() -> float:
	var full_width = (card_width - natural_hand_offset) * cards.size()
	var rect_width = rect.size.x - 2*hand_padding
	var padding = natural_hand_offset
	
	if full_width > rect_width:
		padding = (full_width - rect_width) / (cards.size() - 1) + natural_hand_offset
	
	return padding
	
