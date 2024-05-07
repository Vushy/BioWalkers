extends Node2D
@onready var heartsContainer =  $Characters/health_container
@onready var listItem: ItemList = $questionpanels/ItemList
@onready var questionLabel: Label = $questionpanels/Label/question
@onready var player = $Characters/battlePlayer
@onready var enemy = $Characters/slimebattle
var questions: Array = []
var current_question_index = 0
var start = true

# Enum to handle game states
enum GameState {WAITING_FOR_PLAYER, PLAYER_ATTACK, ENEMY_ATTACK, CHECK_GAME_OVER}
var game_state = GameState.WAITING_FOR_PLAYER

func _ready():
	heartsContainer.setMaxHeart(player.maxHealth)
	heartsContainer.updateHearts(player.Playerhealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	load_questions()
	display_current_question()
	listItem.connect("item_selected", Callable(self, "_on_choice_selected"))
	
	

func _process(delta: float) -> void:
	if start:
		$anim.play('start')
		start = false
	match game_state:
		GameState.PLAYER_ATTACK:
			# Trigger player attack and possibly check for game over
			player_attack()
			game_state = GameState.CHECK_GAME_OVER
		GameState.ENEMY_ATTACK:
			# Trigger enemy attack and possibly check for game over
			enemy_attack()
			game_state = GameState.CHECK_GAME_OVER
		GameState.CHECK_GAME_OVER:
			# Check if the game is over (implement your own logic here)
			if check_game_over():
				end_game()
			else:
				game_state = GameState.WAITING_FOR_PLAYER

func player_attack():
	global.player_attack()
	#$anim.play("move")
	current_question_index += 1
	display_current_question()

func enemy_attack():
	global.enemy_attack()
	#$anim.play("enemyMove")

func _on_choice_selected(index: int) -> void:
	var selected_choice = questions[current_question_index]["choices"][index]
	if selected_choice == questions[current_question_index]["answer"]:
		print("Correct!")
		game_state = GameState.PLAYER_ATTACK
	else:
		print("Wrong")
		game_state = GameState.ENEMY_ATTACK

func check_game_over() -> bool:
	# Implement logic to determine if the game should end
	return false

func end_game() -> void:
	# Handle end of game, such as going to a game over screen or resetting the battle
	print("Game Over!")


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
