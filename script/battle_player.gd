extends CharacterBody2D



func _ready():
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	if global.answerCorrect == true:
		
		
		
		return global.answerCorrect
