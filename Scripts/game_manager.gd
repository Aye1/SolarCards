extends Node
class_name GameManager

const card_template = preload("res://Scenes/card.tscn")
const card_selector = preload("res://Scenes/card_selector.tscn")

var action_card_pool = []
@export var discard_pile:Node2D
@export var play_zone:DropComponent
@export var drag_manager:DragManager
@export var action_deck:CardDeck
@export var location_deck:CardDeck
@export var hand:Hand
@export var location_board:Node2D
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
	drag_manager.draggable_released.connect(_on_draggable_dropped.bind())

func _on_card_dropped_on_play_zone(draggable:Node, dropzone):
	var card:Card = draggable.get_node("..") # TODO: that's not great
	play_card(card)
	
func _fill_decks():
	action_deck.load_from_json("res://Decks/deck_debug.json")
	location_deck.load_from_json("res://Decks/deck_location_debug.json")
	
func _init_game():
	draw_cards(3, "actions")

func _on_draggable_dropped(draggable):
	pass
	#location_board.reorder_cards()

func create_card(path, board) -> Card:
	var new_card = card_template.instantiate()
	new_card.load_json(path)
	board.add_child(new_card)
	drag_manager.register_draggable(new_card.draggable)
	return new_card


func play_card(card):
	hand.remove_card(card)
	for effect in card.effects:
		_process_card_effect(effect)
	discard_pile.discard_card(card)
	
func _process_card_effect(effect):
	match effect.type:
		"draw":
			draw_cards(effect.value, effect.target)
		"debug_print":
			print(effect.value)
		"discard":
			start_discard_selection(effect.value, effect.target)
		"draw_discard":
			draw_and_discard(effect.value, effect.value2, effect.target)
		_:
			printerr("Unknown card effect encountered " + effect.type)
	
func draw_cards(number, pile):
	for i in range(number):
		draw_card(pile)

func draw_card(pile):
	var deck = _get_deck(pile)
	var target = _get_target_displayer(pile)
	var card_path = deck.draw_card()
	if card_path != null:
		var new_card = create_card(card_path, target)
		target.add_card(new_card)
		
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

func _get_target_displayer(key):
	if key in displayers:
		return displayers[key]
	printerr("Trying to access unknown displayer " + key)
		
func start_discard_selection(number, pile):
	temp_selection_pile = pile
	var selector = card_selector.instantiate()
	var displayer = _get_target_displayer(pile) #TODO: selector should probably be a reused object
	var cards = displayer.cards.duplicate()
	displayer.clear()
	selector.set_selectable_cards(cards)
	selector.target_count = number
	selector.selection_type = 0 # This is supposed to be an enum but Godot has some limitations
	selector.selection_done.connect(_on_selection_finished)
	add_child(selector)
	temp_selector = selector
	
func _on_selection_finished(selected_cards, all_cards):
	var displayer = _get_target_displayer(temp_selection_pile)
	var cards = all_cards.duplicate()
	for card in selected_cards:
		cards.erase(card)
		discard_pile.discard_card(card)
	displayer.add_cards(cards)
	temp_selector.queue_free()
	
# TODO: probably need to refactor this with the actual draw_card method
func draw_and_discard(draw_number, discard_number, pile):
	var cards = []
	temp_selection_pile = pile
	var deck = _get_deck(pile)
	var target = _get_target_displayer(pile)
	for i in range(0, draw_number):
		var card_path = deck.draw_card()
		if card_path != null:
			var new_card = create_card(card_path, target)
			cards.append(new_card)
	var selector = card_selector.instantiate()
	selector.set_selectable_cards(cards)
	selector.target_count = discard_number
	selector.selection_done.connect(_on_selection_finished)
	add_child(selector)
	temp_selector = selector
	
