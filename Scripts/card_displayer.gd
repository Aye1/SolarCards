extends Area2D
class_name CardDisplayer

const card_width = Card.card_width
const card_height = Card.card_height

var cards = []
var shape:CollisionShape2D
var rect:Rect2

func _ready():
	shape = $CollisionShape2D
	rect = shape.shape.get_rect()

func add_card(card:Card):
	if not (card in cards):
		cards.append(card)
		reorder_cards()
		
func add_cards(new_cards):
	for card in new_cards:
		if not (card in cards):
			cards.append(card)
			if card.get_parent() != self:
				card.get_parent().remove_child(card)
				add_child(card)
	reorder_cards()
		
func remove_card(card:Card):
	if card in cards:
		cards.erase(card)
		reorder_cards()
		
func clear():
	cards.clear()
		
func reorder_cards() -> void:
	pass # Each child class must implement this
		
	
