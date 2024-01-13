extends CharacterBody2D

# sprite above y-axis for y-sorting purposes
# alt + направление - к предыдущему месту в коде (пргыает даже между файлами)

# particles https://www.youtube.com/watch?v=-ywSvITV_fo
# particles https://www.youtube.com/watch?v=rLsgX8x_Jg4
# todo ue https://www.youtube.com/watch?v=_qxl7CalhDM

# Asset: Dialogue Manager
# Про signals: https://youtu.be/r0DskRhtGNI?t=362

# todo ue добавить меню с управлением и объяснением того, что можно делать
# todo ue добавить границы в мире, за которые нельзя выходить 
# todo ue сделать возможность запуска игры в гитхабе https://youtu.be/PP12lu-C9k4?t=424
# todo ue конфиги: https://steamcommunity.com/sharedfiles/filedetails/?id=3056895446
# todo ue https://youtu.be/_Wo21KAD8OY?t=110 - сделать логгер, state (состояние, которое будет сохраняться)
# todo ue разделить модули на: UI, data, states
# todo ue добавить ускорение и выносливость
# todo ue прыжок и препятствия, возможность перепрыгивать через них + падение в дыру и её перепрыгивание 

# todo fm read godot code style https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
# todo fm рассмотреть asset-ы https://godotengine.org/asset-library/asset
# todo fm идея игра в которой biderectional opposite walk lock (когда идешь в 2 
# противоположные стороны одновременно) - фича и дает какую то способность
# todo fm читать книгу the art of game desgin by jesse shell
# todo fm ознакомиться с godot terrains
# todo fm scoreboard https://www.youtube.com/watch?v=xeoP5CqAi0g

# todo bug решить проблему https://github.com/godotengine/godot/issues/67164 - AtlasTexture?
# todo bug почем то слайм отображается над игроком

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

var currentHealth: int = maxHealth
var prevFrameDirection: String
var isIdle: bool
var isRun: bool
var isHurt: bool

func _ready() -> void:
	effects.play("RESET")

func handleInput() -> void:
	var moveDirection: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
	
	var direction: String = "_down"
	if velocity.x < 0: direction = "_left"
	elif velocity.x > 0: direction = "_right"
	elif velocity.y < 0: direction = "_up"
	
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

# todo ue игрок должен подпрыгивать при knockback (т.е. конечный вектор должен изгибаться)
# todo ue сделать отпрыгиваине медленнее
func knockback(enemyVelocity: Vector2) -> void:
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
