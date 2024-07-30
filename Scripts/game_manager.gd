extends Node
class_name GameManager

const card_template = preload("res://Scenes/card.tscn")
const card_selector_template = preload("res://Scenes/card_selector.tscn")

var action_card_pool = []
@export var discard_pile:DiscardPile
@export var play_zone:DropComponent
@export var drag_manager:DragManager
@export var turn_manager:TurnManager
@export var ui_manager:UiManager
@export var card_selector:CardSelector
@export var action_deck:Deck
@export var location_deck:Deck
@export var hand:Hand
@export var location_board:Node2D
var card_draw:int = 5
var temp_selection_pile
var temp_selector
var decks = {}
var displayers = {}

@export var debug_button:Button

# Called when the node enters the scene tree for the first time.
func _ready():
	# Not all objects are ready when the GameManager is ready
	# So we just defer some initialization to when the whole scene is ready
	_connect_scene_ready()
	_register_decks()
	_register_displayers()

# Deffered initialization
func _on_scene_ready():
	_connect_signals()
	_fill_decks()
	_init_game()
	
func _connect_scene_ready():
	get_tree().root.ready.connect(_on_scene_ready)
	
func _connect_signals():
	play_zone.draggable_dropped.connect(_on_card_dropped_on_play_zone.bind())
	debug_button.pressed.connect(draw_card.bind("actions"))
	turn_manager.turn_changed.connect(_on_new_turn)
	card_selector.selection_done.connect(_on_selection_finished)

func _on_card_dropped_on_play_zone(draggable:DraggableComponent, dropzone):
	var card:Card = draggable.main_object as Card
	if dropzone == play_zone:
		play_card(card)
	else:
		play_character_card(card)
	
func _fill_decks():
	action_deck.load_from_resource("res://Resources/Decks/deck_debug_res.tres")
	location_deck.load_from_resource("res://Resources/Decks/deck_debug_location.tres")
	
func _init_game():
	draw_cards_and_add_to_displayer(card_draw, "actions")
	
func _on_new_turn(turn):
	empty_hand()
	draw_cards_and_add_to_displayer(card_draw, "actions")
	
func create_card(model) -> Card:
	var new_card = card_template.instantiate()
	new_card.card_model = model
	drag_manager.register_draggable(new_card.draggable)
	return new_card

func play_card(card):
	hand.remove_card(card)
	for effect in card.card_model.effects:
		_process_card_effect(effect)
	discard_pile.discard_card(card)
	
func play_character_card(card):
	#TODO: implement
	print("playing card")
	ui_manager.display_inspect_window(card)
	
func _process_card_effect(effect):
	match effect.type:
		"draw":
			draw_cards_and_add_to_displayer(int(effect.value), effect.target)
		"debug_print":
			print(effect.value)
		"discard":
			start_displayer_discard_selection(int(effect.value), effect.target)
		"draw_discard":
			var cards = draw_cards(int(effect.value), effect.target)
			start_discard_selection(int(effect.value2), cards, effect.target)
		_:
			printerr("Unknown card effect encountered " + effect.type)

# Draws and returns several cards
# Does NOT add the cards to the displayer
# You need to do it yourself
# Or use draw_cards_and_add_to_displayer
func draw_cards(number:int, pile) -> Array[Card]:
	var cards:Array[Card] = []
	for i in range(int(number)):
		cards.append(draw_card(pile))
	return cards 

# Draws and return a card
# Does NOT add the card to the displayer
# You need to do it yourself
# Or use draw_cards_and_add_to_displayer
func draw_card(pile) -> Card:
	var deck = _get_deck(pile)
	var card_model = deck.draw_card()
	if card_model != null:
		var new_card = create_card(card_model)
		#TODO: this could be way cleaner
		if pile == "location":
			new_card.drop_component.can_receive_drop = true
			new_card.drop_component.draggable_dropped.connect(_on_card_dropped_on_play_zone)
		return new_card
	return null

func draw_cards_and_add_to_displayer(number:int, pile):
	var cards = draw_cards(number, pile)
	var target = _get_target_displayer(pile)
	target.add_cards(cards) 

func empty_hand():
	var discarded_cards = hand.clear()
	discard_pile.discard_cards(discarded_cards)

func _register_decks():
	decks["actions"] = action_deck
	decks["location"] = location_deck
	
func _register_displayers():
	displayers["actions"] = hand
	displayers["location"] = location_board
		
func _get_deck(key):
	if key in decks:
		return decks[key]
	printerr("Trying to access unknown deck " + key)

func _get_target_displayer(key) -> CardDisplayer:
	if key in displayers:
		return displayers[key]
	printerr("Trying to access unknown displayer " + key)
	return null

# Starts a discard with a specific set of cards
# Useful for discard cards just drawn for example
func start_discard_selection(number:int, cards, pile):
	ui_manager.display_card_selector(cards, number, pile, 0)

# Starts a discard with all the cards from a specific displayer
# Useful for simple discard
func start_displayer_discard_selection(number:int, pile):
	var displayer = _get_target_displayer(pile)
	var cards = displayer.pop_all_cards()
	ui_manager.display_card_selector(cards, number, pile, 0)

func _on_selection_finished(selected_cards, remaining_cards, pile):
	var displayer = _get_target_displayer(pile)
	var cards = remaining_cards
	for card in selected_cards:
		discard_pile.discard_card(card)
	displayer.add_cards(cards)
