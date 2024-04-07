extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var speed = 50
var player_chase = false
var player 
var target_mode = null
var home_pos = Vector2.ZERO

func _ready():
	ap.play("idle")
	

	
	
	
func _physics_process(delta):

	if player_chase == true:
		position += (player.position - position)/speed
		
	move_and_slide()
		
		


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_chase = true
		player = body



func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_chase = false






func _on_battle_activate_body_entered(body):
	if body.has_method("player"):
		call_deferred("_start_battle")
	
		
		
func _start_battle():
	global.enemyCollide = true
