extends CharacterBody2D

@onready var characterAnim = $charAnim
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $attackTimer
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

func _ready():
	animation_tree.active = true
	global.connect("player_should_attack", Callable(self, "on_correct_answer_chosen"))
	global.connect("player_hurt", Callable(self, "on_player_hurt"))
	timer.connect("timeout", Callable(self, "_on_attack_animation_done"))
	hurtTimer.connect("timeout", Callable(self, "player_done_hurt"))
	timer.stop()
	print("Ready function called. Connecting signals and timers.")
	
func on_correct_answer_chosen(correct: bool):
	print("on_correct_answer_chosen triggered with correct:", correct)
	if correct:
		trigger_attack()
	else:
		# Handle incorrect answer if needed
		pass

func trigger_attack():
	print('attacking')
	animation_tree["parameters/conditions/is_attacking"]= true
	idle = false
	timer.start(1)  # Set this to the length of your attack animation
func _on_attack_animation_done():
	print('done atk')
	animation_tree["parameters/conditions/is_attacking"]= false
	# Set any other parameters to return to idle or other state
	animation_tree["parameters/conditions/doneAtk"]= true
	idle = true
	timer.stop()

func on_player_hurt():
	print("player hurt")
	Playerhealth -= 1
	
	print_debug(maxHealth)
	healthChanged.emit(Playerhealth)
	animation_tree["parameters/conditions/is_hurt"]= true
	hurtTimer.start(0.7)
	
	
func player_done_hurt():
	animation_tree["parameters/conditions/is_hurt"]= false
	animation_tree["parameters/conditions/notHurt"] = true
	idle = true
	hurtTimer.stop()
	
func update_param():
	if idle == true:
		animation_tree["parameters/conditions/idle"]= true
	else:
		animation_tree["parameters/conditions/idle"]= false
