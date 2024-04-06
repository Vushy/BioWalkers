extends CharacterBody2D
@onready var enemyAnim = $enemyAnim

var enemyIdle = true

func _ready():
	if enemyIdle == true:
		enemyAnim.play("idle")

func _physics_process(delta):
	if global.answerCorrect == false:
		enemyAnim.play("attack")
	
