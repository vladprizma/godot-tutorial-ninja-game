extends Area2D

@export var speed: int = 155

const MAX_ALIVE_RANGE: int = 1000

var direction: Vector2
var travelled_distance: float = 0

# видимо скорость нужно задавать при спавне, а не внутри объекта, что то с наследованием мешает?
# todo bug сюрикен почему то прозрачный как и тот что у родителя, хотя подразумевается что эти спрайты должны иметь разные свойства
# то что для прицела - прозрачное, то что заспавнилось - непрозрачное 
# в целом: 
# почему то использование одного и того же спрайта в разных местах наследуется родительские свойства
func _ready() -> void:
	direction = get_local_mouse_position().normalized()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	travelled_distance += speed * delta
	
	if travelled_distance > MAX_ALIVE_RANGE:
		queue_free()

# todo почитать комментарии https://www.youtube.com/watch?v=GwCiGixlqiU&t=5468s
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self)
	if body.has_method("player_take_damage"):
		return
	queue_free()
