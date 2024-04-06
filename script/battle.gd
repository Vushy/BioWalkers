extends Node2D

@onready var listItem: ItemList = $questionpanels/ItemList
@onready var questionLabel: Label = $questionpanels/Label/question
var questions: Array = []
var current_question_index = 0

var start = false

func _ready():
	start = true
	load_questions()
	display_current_question()
	listItem.connect("item_selected", Callable(self, "_on_choice_selected"))

func _process(delta: float) -> void:
	if start:
		$anim.play('start')
	start = false

func load_questions() -> void:
	var file = FileAccess.open("res://questions/questions.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()

		var json = JSON.new()
		var error = json.parse(json_text)
		if error == OK:
			questions = json.data["Questions"]
			display_current_question()
		else:
			print("Failed to parse JSON: ", json.get_error_message())
	else:
		print("Failed to open questions file.")

func display_current_question() -> void:
	if current_question_index < questions.size():
		var current_question = questions[current_question_index]
		questionLabel.text = current_question["question"]
		listItem.clear()
		for choice in current_question["choices"]:
			listItem.add_item(choice)
	else:
		print("No more questions.")

func _on_choice_selected(index: int) -> void:
	var selected_choice = questions[current_question_index]["choices"][index]
	if selected_choice == questions[current_question_index]["answer"]:
		print("Correct!")
		global.player_attack()
		current_question_index += 1
		display_current_question()
	else:
		print("Wrong")
		global.enemy_attack()

