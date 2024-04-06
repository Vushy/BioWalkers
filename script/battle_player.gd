extends CharacterBody2D
@onready var characterAnim = $charAnim
@export var speed = 300
var idle = true

func _ready():
	if idle == true:
		characterAnim.play("idle")
		

func _physics_process(delta):
	if global.answerCorrect == true:
		characterAnim.play("run")
		
