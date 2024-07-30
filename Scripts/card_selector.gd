extends Control
class_name CardSelector

signal selection_done(selected_cards, remaining_cards, pile)

enum CardSelectionType { DISCARD = 0 }

@export var accept_button:Button
@export var prompt_label:Label
@export var displayer:CardDisplayer

var target_count:int = 10000 : set = _set_target_count
var selection_type:CardSelectionType = CardSelectionType.DISCARD
var selectable_cards = []
var selected_cards = []
var card_pile

# Called when the node enters the scene tree for the first time.
func _ready():
	accept_button.pressed.connect(_on_accept_button_pressed)

func setup(cards, target, pile, type = 0):
	selectable_cards = cards
	selection_type = type as CardSelectionType
	target_count = target
	card_pile = pile
	displayer.add_cards(selectable_cards)
	_connect_cards()
	_update_prompt_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_enable_button_if_possible()

func _enable_button_if_possible():
	accept_button.disabled = !_can_accept()
	
func _can_accept() -> bool:
	return selected_cards.size() == target_count
	
func _connect_cards() -> void:
	for card in selectable_cards:
		card.selectable.can_be_selected = true
		card.selectable.selected.connect(_on_card_selected.bind(card))
		card.selectable.deselected.connect(_on_card_deselected.bind(card))
		card.draggable.can_be_dragged = false
	
func _release_cards():
	for card in selectable_cards:
		card.selectable.can_be_selected = false
		card.selectable.selected.disconnect(_on_card_selected.bind(card))
		card.selectable.deselected.disconnect(_on_card_deselected.bind(card))
		card.draggable.can_be_dragged = true

func _on_card_deselected(card):
	if card in selected_cards:
		selected_cards.erase(card)
		_update_selectability()

func _on_card_selected(card):
	if selected_cards.size() < target_count:
		selected_cards.append(card)
		_update_selectability()

func _update_selectability():
	for card in selectable_cards:
		card.selectable.can_be_selected = !_can_accept()
			
func _on_accept_button_pressed():
	var selected = selected_cards.duplicate()
	var remaining = []
	for card in selectable_cards:
		if card not in selected:
			remaining.append(card)
	selection_done.emit(selected, remaining, card_pile)

func _set_target_count(value):
	target_count = min(value, selectable_cards.size())
	
func _update_prompt_label():
	if prompt_label == null:
		return
	var new_text = ""
	match selection_type:
		CardSelectionType.DISCARD:
			new_text = "Choose " + str(target_count) + " card(s) to discard"
	prompt_label.text = new_text
	
func clear():
	_release_cards()
	selectable_cards.clear()
	selected_cards.clear()
	displayer.clear()
			
