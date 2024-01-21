extends CharacterBody2D

# sprite above y-axis for y-sorting purposes
# alt + (влево/вправо) - к предыдущему месту в коде (пргыает даже между файлами)
# ctrl + d - выделяет совпадения выделенного текста
# ctrl + shift + o - позволяет искать по все созданным сценам

# particles https://www.youtube.com/watch?v=-ywSvITV_fo
# particles https://www.youtube.com/watch?v=rLsgX8x_Jg4
# todo ue https://www.youtube.com/watch?v=_qxl7CalhDM

# Asset: Dialogue Manager
# Про signals: https://youtu.be/r0DskRhtGNI?t=362

# сигналы лучше всего подходят для ситуаций, когда нам нужно передавать 
# информацию вверх по цепочке иерархий, от наследника к родителю
signal healthChanged

@export var speed: int = 35
@export var runSpeedScale: float = 1.7
@export var maxHealth: int = 3
@export var knockbackPower: int = 1000

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var effects: AnimationPlayer = $Effects
@onready var hurtTimer: Timer = $HurtTimer
@onready var hurtBox: Area2D = $HurtBox
@onready var dustTrail: GPUParticles2D = $GPUParticles2D

var moveDirection: Vector2
var currentHealth: int = maxHealth
var prevFrameDirection: String
var isIdle: bool
var isRun: bool
var isHurt: bool

func _ready() -> void:
	effects.play("RESET")

func handleInput() -> void:
	moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	isIdle = velocity.length_squared() == 0
	isRun = Input.is_key_pressed(KEY_SHIFT) and !isIdle
	if isRun:
		velocity *= runSpeedScale

# Метод должен вызываться после handleInput()
func updateAnimation() -> void:
	if isIdle or !isRun:
		dustTrail.emitting = false
	if isIdle:
		if animations.is_playing():
			animations.play("idle" + prevFrameDirection)
			animations.stop()
		return # если !animations.is_playing(), то возвращаемся тоже
	
	# todo на джойстике указание верхней стороны ходьбы не включает соответствующую анимацию
	var direction: String = "_down"
	if moveDirection.x < 0: direction = "_left"
	elif moveDirection.x > 0: direction = "_right"
	elif moveDirection.y < 0: direction = "_up"
	
	prevFrameDirection = direction
	if isRun:
		animations.play("run" + direction)
		dustTrail.emitting = true # todo ue в зависимости от стороны в которую игрок идет менять точку спавна пыли, на теле
		return
	animations.play("walk" + direction)

func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	updateAnimation()
	checkHurt()

func checkHurt() -> void:
	if isHurt:
		return
	for area in hurtBox.get_overlapping_areas():
		if area.name == "HitBox":
			hurtByEnemy(area)

func hurtByEnemy(area: Area2D) -> void:
	currentHealth -= 1
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurt_blink")
	hurtTimer.start()
	await hurtTimer.timeout
	isHurt = false
	effects.play("RESET")
	# todo ue не нравится, что можно идти в ту же сторону в которой получил урон
	# думаю чтоит вообще отключить управление на время анимации получнеия урона
	if currentHealth <= 0:
		currentHealth = maxHealth

func knockback(enemyVelocity: Vector2) -> void:
	var knockbackDirection: Vector2 = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.has_method("check_type") && area.check_type("Collectable"):
		area.collect()
