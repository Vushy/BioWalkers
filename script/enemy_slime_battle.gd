extends CharacterBody2D
@onready var enemyAnim = $enemyAnim
@onready var anim_tree :  AnimationTree = $AnimationTree
@onready var timer: Timer = $attackTimer
@onready var moveTimer: Timer = $movetimer
@onready var hurtTimer: Timer = $enemyHurt
@onready var enemyHealthbar = $enemyHealth
var enemyIdle = true
var hurt =  false
var enemyHealth = 10
var playerDamage:int = global.playerDmg
var enemyState

func _ready():
	anim_tree.active = true
	enemyState = anim_tree['parameters/playback']
	if enemyIdle == true:
		enemyState.travel('idle')
	else:
		pass
	
	enemyHealthbar.value = enemyHealth
	print(enemyHealthbar.value)
	print(playerDamage)
	global.connect("enemy_should_attack", Callable(self, "_on_enemy_should_attack"))
	global.connect("enemy_hurt", Callable(self, "_on_enemy_hurt"))
	global.connect("enemy_should_advance",Callable (self, "enemyAdvance"))
	global.connect('enemy_should_retreat', Callable (self, "enemyRetreat"))
	moveTimer.connect('timeout', Callable(self, "enemyAdvance"))
	hurtTimer.connect("timeout", Callable(self, "enemyHurt"))
	timer.stop()
	
	
	
func _physics_process(delta):
	update_global_position()
	move_and_slide()


func update_global_position():
	global.set_enemy_position(global_position)




func enemyAdvance():
	if global.enemyMove == true:
		enemyState.travel('move')
		moveTimer.start(1)
		print('moving')

func _on_enemy_should_attack():
	if global.answerCorrect == false:
		enemyState.travel('attack')
		moveTimer.stop()
		
func enemyRetreat():
	if global.enemyRetreat == true:
		$enemySprite.flip_h = true
		enemyState.travel('move')
		await get_tree().create_timer(1.85).timeout
		$enemySprite.flip_h = false
		enemyState.travel('idle')
func _on_enemy_hurt():
	print('enemy Hurt')
	enemyState.travel('hurt')
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
	if enemyHealthbar.value == 0:
		global.enemyDead = true
		enemyState.travel('death')
		print('the enemy is dead')

	
	

		
