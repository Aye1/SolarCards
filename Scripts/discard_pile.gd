extends Node
class_name DiscardPile

var count_label

var discarded_cards = []

# Called when the node enters the scene tree for the first time.
func _ready():
	count_label = $CountLabel
	_update_label()

func _update_label():
	count_label.text = str(discarded_cards.size())

func discard_card(card:Card):
	discarded_cards.append(card)
	card.get_parent().remove_child(card)
	add_child(card)
	card.visible = false
	_update_label()

func discard_cards(cards):
	for card in cards:
		discard_card(card)

