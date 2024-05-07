extends Node

#video lessons
var play = false
var videoFinished = false

#scene transistions
var current_scene = "world"
var transition_scene = false
var enemyCollide = false

#players position
var player_exit_pos_x = 584
var player_exit_pos_y = 251
var player_start_pos_x = 5
var player_start_pos_y = 73
var player_pos = Vector2.ZERO

#dialogues
var dialogueFinished = false
var dialogueStarted = false
var game_first_loadin = true

#battle scenes variable
var answerCorrect
var attack 
var moving
var enemyAtk
var enemyMove
var player_alive = false
# conditions
var Correct 
var playerDmg = 1

signal player_should_attack(Correct)
signal player_hurt
signal enemy_should_attack
signal enemy_hurt

func set_player_position(position):
	print(player_pos)
	player_pos = position

func get_player_position():
	return player_pos

	


func player_attack():
	answerCorrect = true
	attack = true
	moving = true
	
	# Emit signal with the current enemy position for the player to move and attack
	emit_signal("player_should_attack", get_enemy_position())
	emit_signal("enemy_hurt")
	print("Signal emitted to attack at position: ", get_enemy_position())
	return playerDmg
func enemy_attack():
	answerCorrect = false
	enemyAtk = true
	enemyMove = true
	emit_signal("enemy_should_attack")  # Emit the signal when the enemy attacks
	emit_signal("player_hurt")

func set_enemy_position(position):
	answerCorrect = true

func get_enemy_position():
	
	return answerCorrect



func finish_changescene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "nworld"
		else:
			current_scene = "world"

