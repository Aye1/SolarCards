extends Area2D
class_name CardDisplayer

const card_width = Card.card_width
const card_height = Card.card_height

@export var lock_cards:bool = true
var cards:Array[Card]
var shape:CollisionShape2D
var rect:Rect2

func _ready():
	shape = $CollisionShape2D
	rect = shape.shape.get_rect()

func add_card(card:Card) -> void:
	if not (card in cards):
		if lock_cards:
			card.draggable.can_be_dragged = false
		cards.append(card)
		reorder_cards()
		
func add_cards(new_cards) -> void:
	for card in new_cards:
		if not (card in cards):
			if lock_cards:
				card.draggable.can_be_dragged = false
			cards.append(card)
			if !card.get_parent():
				add_child(card)
			elif card.get_parent() != self:
				card.get_parent().remove_child(card)
				add_child(card)
	reorder_cards()
		
func remove_card(card:Card) -> void:
	if card in cards:
		cards.erase(card)
		reorder_cards()

func pop_all_cards() -> Array[Card]:
	var removed_cards = cards.duplicate()
	cards.clear()
	return removed_cards
	
func clear():
	cards.clear()
		
func reorder_cards() -> void:
	pass # Each child class must implement this
		
	
