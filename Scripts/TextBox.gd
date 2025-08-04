extends CanvasLayer

const CHAR_READ_RATE = 0.12
var OG_SPEED
@onready var textbox_container = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var dialogue = $TextBoxContainer/MarginContainer/HBoxContainer/Dialogue
var tween = create_tween()
@onready var player: CharacterBody2D = %Player


enum State{
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
	
	

func _on_ready() -> void:
	textbox_container.hide()

func _on_dialogue_encounter_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		OG_SPEED = body.SPEED
		print("Starting state: READY")
		hide_textbox()
		queue_text("Hello weary traveller...how ye be...")
		queue_text("Long long ago in the king-")
		queue_text("Ah fuck it, who am I kidding..")
		queue_text("You just want the lore and instructions right?")
		queue_text("Arrows for movement (or w a d if yer a gamer)")
		queue_text("There's double jumps and spacebar for attack")
		queue_text("Fruits heal you..")
		queue_text("Defeat all the enemies and save the princess")
		queue_text("Yada yada yada, you know the speal")
		queue_text("Oh and the lamp-posts are checkpoints, thats about it")
		queue_text("Goodluck!")
		

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	dialogue.text = ""
	textbox_container.hide()
	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	
func display_text():
	dialogue.text = text_queue.pop_front()
	change_state(State.READING)
	show_textbox()
	dialogue.visible_ratio = 0
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(dialogue, "visible_ratio", 1, len(dialogue.text)*CHAR_READ_RATE) 
	change_state(State.FINISHED)
	await tween.finished
	end_symbol.text = "v"

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("READY")
		State.READING:
			print("READING")
		State.FINISHED:
			print("FINISHED")
