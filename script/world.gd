extends Node2D


@onready var transition = $"."/transition
@onready var player = $player
@onready var heartsContainer =  $CanvasLayer/HBoxContainer

func _ready():
	transition.play("fade_in")
	heartsContainer.setMaxHeart(player.maxHealth)
	heartsContainer.updateHearts(player.Playerhealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	
	
	if global.game_first_loadin == true:
		$player.position.y = global.player_start_pos_y
		$player.position.x = global.player_start_pos_x
		
	else:
		$player.position.x = global.player_exit_pos_x
		$player.position.y = global.player_exit_pos_y
		
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	
func dialogueStart():
	if global.dialogueStarted == true:
		pass
func dialogueFinished():
	if global.dialogueFinished == true:
		pass


func _on_nworld_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		


func _on_nworld_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scene/nworld.tscn")
			global.game_first_loadin = false
			global.finish_changescene
	if global.play == true:
		get_tree().change_scene_to_file("res://scene/video.tscn")
		global.play = false
		global.game_first_loadin = false
		
	if global.videoFinished == true:
		$player.global_position = global.get_player_position()
		global.videoFinished = false
		global.game_first_loadin = false
