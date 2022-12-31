extends Node2D

const CARD_ROTATION := deg2rad(15.0)
const CARD_SIZE := Vector2(250,350)

var card_scene = preload("res://scenes/Card/Card.tscn")

export var hand_size := 2
export var height_curve: Curve
export var rotation_curve: Curve

onready var hand: Node2D = $Hand
onready var deck: Area2D = $Deck
onready var cards_resting_place: Area2D = $Discard

var card_stack := []
var dancer 


func _ready() -> void:
	deck.connect("clicked", self, "_create_and_animate_cards")
	cards_resting_place.connect("area_entered", self, "_on_CardsRestingPlace_area_entered")


func _create_and_animate_cards() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	if not hand.get_children().empty():
		for child in hand.get_children():
			tween.tween_property(child, "position", cards_resting_place.position, 1)
	
	Global.rng.randomize()
	var card_count := int(Global.rng.randi_range(1, 5))
	card_count = 4
	
	for child_index in card_count:
		var new_card = card_scene.instance()
		#new_card.card_art = preload("res://assets/blackhole.png")
		#new_card.card_name = "Black Hole"
		new_card.position = deck.position
		new_card.scale = Vector2.ZERO
		new_card.croupier = self
		hand.add_child(new_card)
		add_child(new_card)
		
		var ratio_in_hand := float(child_index) / card_count
		var target_position := Vector2((child_index + 0.5 - card_count * 0.5),0)
		target_position.x *= CARD_SIZE.x*0.8
		var base_scale = CARD_SIZE/new_card.SIZE*0.8
		new_card.BASE_SCALE = base_scale
		
		tween.tween_property(new_card, "scale", base_scale, 0.2)
		tween.parallel().tween_property(new_card, "position", target_position, 0.5)


func _on_CardsRestingPlace_area_entered(card: Node) -> void:
	card.queue_free()


func add_card(card_) -> void:
	card_stack.append(card_)
	
	var count = 0
	
	for card in card_stack:
		card.z_index = count
		card.unzoom()
		count += 1


func push_card_on_top(card_) -> void:
	card_stack.erase(card_)
	add_card(card_)
	card_.zoom()


func fill_hand():
	discard_hand()
	
	for part in dancer.part.keys():
		while dancer.part[part].hand.size() < dancer.part[part].draw && !dancer.part[part].empty:
			draw_part(part)
	
	mix_parts()


func draw_part(part_):
	if dancer.part[part_].deck.size() > 0:
		dancer.part[part_].option.append(dancer.part[part_].deck.pop_front())
	else:
		regain_discard(part_)
		
		if dancer.part[part_].deck.size() == 0:
			dancer.part[part_].empty = true
		else:
			dancer.part[part_].option.append(dancer.part[part_].deck.pop_front())


func regain_discard(part_):
	while dancer.part[part_].discard.size() > 0:
		dancer.part[part_].deck.append(dancer.part[part_].discard.pop_front())


func check_12_king():
	if dancer.team == "champion":
		var data = {}
		data.part = "pas"
		data.layer = 12
		data.chesspiece = "king"
		data = get_part(data)
		
		if data.part != null:
			if data.stack != "hand":
				dancer.part[data.part][data.stack].append(dancer.part[data.part].hand.pop_back())
				dancer.part[data.part][data.stack].erase(data.part)
				dancer.part[data.part].hand.append(data.part)


func get_part(data_):
	data_.stack = null
	data_.part = null
	
	for stack in Global.arr.stack: 
		for part in dancer.part[data_.part][stack]:
			match data_.part:
				"pas":
					if part.num.layer == data_.layer && part.word.chesspiece == data_.chesspiece:
						data_.part = part
						data_.stack = stack
						return data_
	return data_


func mix_parts():
	var n = min(dancer.part.pas.draw,dancer.part.pas.exam)
	
	for part in dancer.part.keys():
		dancer.part[part].option.shuffle()
	
	for _i in n:
		for part in dancer.part.keys():
			dancer.part[part].hand.append(dancer.part[part].option.pop_front()) 
	
	check_12_king()
	
	for _i in n:
		var data = {}
		data.temp = dancer.team == "mob"
		data.croupier = self
		
		for part in dancer.part.keys(): 
			data[part] = dancer.part[part].hand[_i]
		
		var new_card = card_scene.instance()
		new_card.set_vars(data)
		add_card(new_card)


func discard_hand():
	for part in dancer.part.keys():
		while dancer.part[part].hand.size() > 0:
			var hand = dancer.part[part].hand.pop_front()
			dancer.part[part].discard.append(hand)
		
		while dancer.part[part].option.size() > 0:
			var option = dancer.part[part].option.pop_front()
			dancer.part[part].discard.append(option)
		
		if dancer.part[part].discard.size() > 0:
			dancer.part[part].empty = false

