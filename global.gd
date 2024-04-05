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




func set_player_position(position):
	print(player_pos)
	player_pos = position

func get_player_position():
	return player_pos


func finish_changescene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "nworld"
		else:
			current_scene = "world"

