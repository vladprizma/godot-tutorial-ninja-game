extends CharacterBody2D
# https://www.youtube.com/watch?v=9k8cMzv0ZNo
# layers determine what can detect me
# masks determine what i can detect

# sprite above y-axis for y-sorting purposes
# во вкладке 2D можно заметить, что незакрашенная часть спрайта снизу под осью y, 
# потому что мы не будем учитывать пустые клетки при сортировке текстур
@export var speed: int = 30 # медленнее чем игрок
@export var limit: float = 0.5
@export var endPoint: Marker2D

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $"../Player"

const SPRITE_SIZE_PIXELS = 16
var moveDirection: Vector2
var health: int = 2

# todo ue сделать чтобы слайм не мог передвигаться когда на земле, а передвигался прыжками
# todo ue обычно 5 FPS, но когда следует за игроком - около 10
# todo bug противники должны обходить препятствия если врезаются
func updateVelocity() -> void:
	moveDirection = global_position.direction_to(player.global_position)
	velocity = moveDirection.normalized() * speed

func updateAnimation() -> void:
	var direction: String = "_down"
	if moveDirection.x < 0: direction = "_left"
	elif moveDirection.x > 0: direction = "_right"
	elif moveDirection.y < 0: direction = "_up"
	
	animations.play("walk" + direction)

func take_damage(area: Area2D) -> void:
	health -= 1
	if health == 0:
		queue_free()

func _physics_process(_delta: float) -> void:
	updateVelocity()
	move_and_slide()
	updateAnimation()
