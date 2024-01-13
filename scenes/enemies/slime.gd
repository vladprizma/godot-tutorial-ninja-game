extends CharacterBody2D
# https://www.youtube.com/watch?v=9k8cMzv0ZNo
# layers determine what can detect me
# masks determine what i can detect

# sprite above y-axis for y-sorting purposes
# можно заметить что незакрашенная часть спрайта снизу под осью y, 
# потому что мы не будем учитывать пустые клетки при сортировке текстур
@export var speed: int = 30 # медленнее чем игрок
@export var limit: float = 0.5
@export var endPoint: Marker2D

@onready var animations: AnimationPlayer = $AnimationPlayer

const SPRITE_SIZE_PIXELS = 16
var startPosition: Vector2
var endPosition: Vector2
var distance: Vector2

func _ready() -> void:
	startPosition = position
	endPosition = endPoint.global_position

# todo ue сделать чтобы слайм не мог передвигаться когда на земле 
# todo ue обычно 5 FPS, но когда следует аза игроком - около 10
func updateVelocity() -> void:
	var moveDirection: Vector2 = endPosition - position
	if moveDirection.length() < limit:
		var tempVector: Vector2 = endPosition
		endPosition = startPosition
		startPosition = tempVector
	velocity = moveDirection.normalized() * speed

func updateAnimation() -> void:
	var direction: String = "_down"
	if velocity.x < 0: direction = "_left"
	elif velocity.x > 0: direction = "_right"
	elif velocity.y < 0: direction = "_up"
	
	animations.play("walk" + direction)

func _physics_process(delta: float) -> void:
	updateVelocity()
	move_and_slide()
	updateAnimation()
