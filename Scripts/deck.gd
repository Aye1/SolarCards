extends Node
class_name Deck

var count_label:Label

var cards = []
var rng
var deck_model:DeckResource

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	count_label = $CountLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	count_label.text = str(cards.size())

func load_from_resource(path:String) -> void:
	if !FileAccess.file_exists(path):
		printerr("File does not exist: " + path)
		return
	deck_model = load(path)
	_expand_card_list()
	
func _expand_card_list():
	if cards:
		cards.clear()
		
	for card in deck_model.cards:
		for i in range(0, card.count):
			cards.append(card.resource)

func _add_card(card) -> void:
	cards.append(card)

func draw_card() -> CardResource:
	if !deck_model.cards.is_empty():
		var index = rng.randi_range(0, cards.size()-1)
		var next_card = cards.pop_at(index)
		return next_card
	return null
		

