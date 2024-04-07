extends Node2D
@onready var transition = $"."/transition
@onready var player = $player
@onready var heartsContainer =  $CanvasLayer/HBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	transition.play("fade_in")
	heartsContainer.setMaxHeart(player.maxHealth)
	heartsContainer.updateHearts(player.Playerhealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	
	if global.enemyCollide == true:
		transition.play('fade_out')




func _on_world_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_world_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scene/world.tscn")
			global.finish_changescene
	


func _on_transition_animation_finished(anim_name):
	if global.enemyCollide == true:
		get_tree().change_scene_to_file("res://scene/battle.tscn")
