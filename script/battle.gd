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
			display_current_question()  # Display the first question
		else:
			print("Failed to parse JSON: ", json.get_error_message())
	else:
		print("Failed to open questions file.")

func display_current_question():
	if current_question_index >= questions.size():
		print("No more questions.")
		return

	questionLabel.text = questions[current_question_index]["question"]
	listItem.clear()
	for choice in questions[current_question_index]["choices"]:
		listItem.add_item(choice)
	listItem.connect("item_selected", Callable(self, "_on_choice_selected"))


func _on_choice_selected(index: int):
	listItem.disconnect("item_selected", Callable(self, "_on_choice_selected"))  # Prevent multiple connections
	var selected_choice = questions[current_question_index]["choices"][index]
	if selected_choice == questions[current_question_index]["answer"]:
		print("Correct!")
		current_question_index += 1
		if current_question_index < questions.size():
			display_current_question()
		else:
			print("You've completed all questions.")
	else:
		print("Wrong")
