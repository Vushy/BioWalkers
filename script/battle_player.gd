extends CharacterBody2D

@onready var characterAnim = $charAnim
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $attackTimer
@onready var moveTimer: Timer = $movingTimer
@onready var hurtTimer: Timer = $hurtTimer
@export var speed = 500
@export var maxHealth = 3
@onready var Playerhealth : int = maxHealth

signal healthChanged

var idle = true
var moving_to_enemy = false
var returning_to_original_position = false
var enemy_position: Vector2
var attack_position_offset = Vector2(50, 0)
var original_position = Vector2(89, 0)
var playerState
var flip

func _ready():
	animation_tree.active = true
	playerState = animation_tree['parameters/playback']
	if idle == true:
		
		playerState.travel('idle')
	else:
		idle = false
		return 
	global.connect("player_should_attack", Callable(self, "on_correct_answer_chosen"))
	global.connect("player_hurt", Callable(self, "on_player_hurt"))
	timer.connect("timeout", Callable(self, "_on_attack_animation_done"))
	hurtTimer.connect("timeout", Callable(self, "player_done_hurt"))
	timer.stop()
	print("Ready function called. Connecting signals and timers.")
	
func on_correct_answer_chosen(correct: bool):
	print("on_correct_answer_chosen triggered with correct:", correct)
	if correct:
		playerAdvancing()
	else:
		# Handle incorrect answer if needed
		pass
		
func playerAdvancing():
	playerState.travel('run')
	await get_tree().create_timer(1.5).timeout
	trigger_attack()
	
func trigger_attack():
	print('attacking')
	playerState.travel('attack')
	idle = false
	await get_tree().create_timer(1).timeout
	$charSprite.flip_h = true
	playerRetreat()
 # Set this to the length of your attack animation
	

	
func playerRetreat():
	#flip = global.playerFinishedAtk
	playerState.travel('run')
	await get_tree().create_timer(1.85).timeout
	$charSprite.flip_h = false
	playerState.travel('idle')

	
func on_player_hurt():
	print("player hurt")
	Playerhealth -= 1
	
	print_debug(Playerhealth)
	healthChanged.emit(Playerhealth)
	animation_tree["parameters/conditions/is_hurt"]= true
	hurtTimer.start(0.7)
	playerDeath()
	
func player_done_hurt():
	animation_tree["parameters/conditions/is_hurt"]= false
	animation_tree["parameters/conditions/notHurt"] = true
	idle = true
	hurtTimer.stop()
	
func playerDeath():
	if Playerhealth == 0:
		print('player Dead')
		playerState.travel('death')
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://scene/death_scene.tscn")
		global.player_alive = false
