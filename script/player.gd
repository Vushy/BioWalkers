extends CharacterBody2D
@export var maxHealth = 3
@onready var Playerhealth : int = maxHealth
const SPEED = 80
signal healthChanged
var current_dir = "none"
var NPC_IN_RANGE = false
var lesson_npc = false
func _ready():
	$AnimatedSprite2D.play("front_idle")


func _physics_process(delta):
	
	if NPC_IN_RANGE == true:
		if Input.is_action_just_pressed("chat"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")
			return

	player_movement(delta)
	current_cam()


#player movement
func player_movement(delta):
	if Input.get_action_strength("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.get_action_strength("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.get_action_strength("up") :
		current_dir = "up"
		play_anim(1)
		velocity.y = -SPEED
		velocity.x = 0
	elif Input.get_action_strength("down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = SPEED
		velocity.x = 0
	else: 
		play_anim(0)
		velocity.y = 0 
		velocity.x = 0
	if 	velocity.x or velocity.y != 0 or $AudioStreamPlayer2D/Timer.time_left <= 0:
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D/Timer.start(0.2)
	else:
		$AudioStreamPlayer2D/Timer.stop()
		$AudioStreamPlayer2D.stop()
			
			
		
			
		
		
	move_and_slide()
#movement animation
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
			
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	elif dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

func player():
	pass



func _on_area_2d_body_entered(body):
	if body.has_method("NPC"):
		NPC_IN_RANGE = true
		print("inside")
	elif body.name == "lesson_npc":
		lesson_npc == true
		global.set_player_position(global_position)
		print("inside")


func _on_area_2d_body_exited(body):
	if body.has_method("NPC"):
		NPC_IN_RANGE = false



func current_cam():
	if global.current_scene == "world":
		$worldcam.enabled = true
		$nworldcam.enabled = false
	elif global.current_scene == 'nworld':
		$worldcam.enabled = false
		$nworldcam.enabled = true
		
