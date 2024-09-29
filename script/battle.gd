extends Node2D
@onready var heartsContainer =  $Characters/health_container
@onready var listItem: ItemList = $questionpanels/ItemList
@onready var questionLabel: Label = $questionpanels/Label/question
@onready var player = $Characters/battlePlayer
@onready var enemy = $Characters/slimebattle
var questions: Array = []
var current_question_index = 0
var start = true
var playerRetreat 
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
			player_advance()
			game_state = GameState.CHECK_GAME_OVER
		GameState.ENEMY_ATTACK:
			# Trigger enemy attack and possibly check for game over
			enemy_advance()
			game_state = GameState.CHECK_GAME_OVER
		GameState.CHECK_GAME_OVER:
			# Check if the game is over (implement your own logic here)
			check_game_over()
				
	
	
func player_advance():
	global.player_Adv()
	$anim.play("move")
	await $anim.animation_finished
	if $anim.animation_finished:
		
		#print('animationdone')
		player_attack()
		
func player_attack():
	global.player_attack()
	#print('player atack')
	current_question_index += 1
	display_current_question()
	playerRetreat = true
	
	await get_tree().create_timer(1).timeout
	player_retreat()


func player_retreat():

	if playerRetreat == true:
		$anim.play("playerReturn")
		
		
func enemy_advance():
	$anim.play("enemyMove")
	global.enemyAdv()
	await $anim.animation_finished
	if $anim.animation_finished:
		enemy_attack()

func enemy_attack():
	global.enemy_attack()
	await get_tree().create_timer(0.5).timeout
	enemy_retreat()

func enemy_retreat():
	$anim.play('enemy_retreat')
	global.enemyRet()

func _on_choice_selected(index: int) -> void:
	var selected_choice = questions[current_question_index]["choices"][index]
	if selected_choice == questions[current_question_index]["answer"]:
		print("Correct!")
		game_state = GameState.PLAYER_ATTACK
	else:
		print("Wrong")
		game_state = GameState.ENEMY_ATTACK

func check_game_over():
	if global.playerDead() == true:
		$anim.play('death')
		end_game()
	else:
		pass
func end_game():
	pass


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
