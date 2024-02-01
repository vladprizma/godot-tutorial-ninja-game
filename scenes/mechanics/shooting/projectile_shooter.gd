extends Marker2D

@onready var cooldown: Timer = $Cooldown

const SHURIKEN: Resource = preload("res://scenes/collectables/projectiles/shuriken.tscn")

var isShot: bool

# todo ue сделать "замах" перед выстрелом, замахи должны быть рандомно либо с одной стороны либо с другой с остаточной белой дугой от замаха
# todo ue по пули при врезании во что либо должны проподать
# todo ue спрайт должен браться из предемета в руке (куда должен попадать первый предмет из инвентаря) + делать прозрачным

# todo bug тут по любому баг если мышка будет между спавном точки выстрела и игрока
# элементы будут лететь в другую сторону относительно той в которую целится модель
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot() # todo добавить действие на левую кнопку мыши

func shoot() -> void:
	if isShot:
		return
	var new_projectile: Area2D = SHURIKEN.instantiate()
	new_projectile.global_position = %ShootingPoint.global_position
	%ShootingPoint.add_child(new_projectile)
	cooldown.start()
	isShot = true
	# todo ue если кликаешь по мышке то стрельба должна быть быстрее, нежели удерживаешь
	await cooldown.timeout
	isShot = false
	# todo после верхней todo продолжить просмотр https://youtu.be/GwCiGixlqiU?t=5468
