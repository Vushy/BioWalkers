extends CharacterBody2D
@onready var enemyAnim = $enemyAnim
@onready var anim_tree :  AnimationTree = $AnimationTree
@onready var timer: Timer = $attackTimer
@onready var hurtTimer: Timer = $enemyHurt
@onready var enemyHealthbar = $enemyHealth
var enemyIdle = true
var hurt =  false
var enemyHealth = 10
var playerDamage:int = global.playerDmg

func _ready():
	anim_tree.active = true
	enemyHealthbar.value = enemyHealth
	print(enemyHealthbar.value)
	print(playerDamage)
	global.connect("enemy_should_attack", Callable(self, "_on_enemy_should_attack"))
	global.connect("enemy_hurt", Callable(self, "_on_enemy_hurt"))
	timer.connect("timeout", Callable(self, "_on_attack_animation_done"))
	hurtTimer.connect("timeout", Callable(self, "enemyHurt"))
	timer.stop()
	
	
	
func _physics_process(delta):
	update_global_position()
	update_enemy_animTree()
	move_and_slide()
	


func update_global_position():
	global.set_enemy_position(global_position)


func _on_enemy_should_attack():
	if global.answerCorrect == false:
		anim_tree["parameters/conditions/is_attacking"] = true
		timer.start(0.5)
func _on_attack_animation_done():
	anim_tree["parameters/conditions/is_attacking"]= false
	# Set any other parameters to return to idle or other state
	anim_tree["parameters/conditions/doneAtk"]= true
	timer.stop()
	
	
	
func _on_enemy_hurt():
	print('enemy Hurt')
	anim_tree["parameters/conditions/hurt"]= true
	hurtTimer.start(0.5)
	updateEnemyHealth()
func enemyHurt():
	print('done hurt')
	anim_tree["parameters/conditions/hurt"]= false
	anim_tree["parameters/conditions/done_hurt"]= true
	enemyIdle = true
	hurtTimer.stop()
	
	
func updateEnemyHealth():
	enemyHealthbar.value -= playerDamage
	print(enemyHealthbar.value)
func update_enemy_animTree():
	if enemyIdle == true:
		anim_tree["parameters/conditions/idle"] = true
		anim_tree["parameters/conditions/move"] =  false
		

