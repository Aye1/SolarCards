extends Node2D
class_name CardSelector

const scale_ratio = 1.2

signal selection_done(selected_cards, all_cards)

var target_count = 10000
var selectable_cards = []
var selected_cards = []
var base_scale

var accept_button:Button
var displayer:CardDisplayer

# Called when the node enters the scene tree for the first time.
func _ready():
	accept_button = $AcceptButton
	displayer = $CardDisplayer
	displayer.add_cards(selectable_cards)
	if !selectable_cards.is_empty():
		base_scale = selectable_cards[0].scale
	_connect_cards()
	accept_button.pressed.connect(_on_accept_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_enable_button_if_possible()
	
func _input(event):
	pass
	#if event is InputEventMouse:
	#	get_viewport().set_input_as_handled() 
	
func _enable_button_if_possible():
	accept_button.disabled = !_can_accept()
	
func _can_accept() -> bool:
	return selected_cards.size() == target_count
	
func _connect_cards() -> void:
	for card in selectable_cards:
		card.selected.connect(_on_card_selected.bind(card))
		
func _on_card_selected(card):
	if card in selected_cards:
		selected_cards.erase(card)
		card.is_selected = false
	else:
		if selected_cards.size() < target_count:
			selected_cards.append(card)
			card.is_selected = true
			
func _on_accept_button_pressed():
	selection_done.emit(selected_cards, selectable_cards)
	
func set_selectable_cards(cards):
	selectable_cards = cards
