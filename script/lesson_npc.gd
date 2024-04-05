extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var interacting = false

var player
var player_interact_zone = false



func _ready():
	randomize()
	start_pos = position


enum{
	IDLE,
	NEW_DIR,
	MOVE
}



	
func _process(delta):
	if current_state == 0 or current_state == 1:
		$anim.play("idle")
	elif current_state == 2 and !interacting:
		if dir.x == -1:
			$anim.play("walk_left")
		if dir.x == 1:
			$anim.play("walk_right")
		if dir.y == -1:
			$anim.play("walk_up")
		if dir.y == 1:
			$anim.play("walk_down")
			
			
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
			MOVE:
				move(delta)
	move_and_slide()
	
	
	if player_interact_zone == true:
		if Input.is_action_just_pressed("chat"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "video_lesson")
			is_roaming = false
			interacting = true
			return
			
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !interacting:
		position += dir * speed * delta
		

func lesson_npc():
	if global.dialogueFinished == true:
		is_roaming = true
		interacting = false
		return

func _on_interact_zone_body_entered(body):
	if body.has_method("player"):
		player = body
		player_interact_zone = true
		print("chatting with npc")


func _on_interact_zone_body_exited(body):
	if body.has_method("player"):
		player_interact_zone = false



func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
