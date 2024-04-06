extends CharacterBody2D
@onready var enemyAnim = $enemyAnim

var enemyIdle = true
var hurt =  false
func _ready():
	if enemyIdle == true:
		enemyAnim.play("idle")

func _physics_process(delta):
	if global.answerCorrect == false:
		enemyAnim.play("move")
	
	if hurt == true:
		enemyAnim.play("hurt")


func _on_area_2d_body_entered(body):
	if body.has_method("battlePlayer"):
		hurt = true
		print("inside")
