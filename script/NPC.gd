extends CharacterBody2D

var animated_sprite


func _ready():
	animated_sprite = $AnimatedSprite2D
	
	animated_sprite.play('idle')
	
func _process(delta):
	animated_sprite.play('idle')
	
func NPC():
	pass
