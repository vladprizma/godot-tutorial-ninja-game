extends Camera2D

@export var ignoreX = false
@export var ignoreY = false

@export var tileMap: TileMap
@export var deadZone: float = 160.0
@export var mouseMoveAmount: Vector2 = Vector2(0.3, 0.3)
@export var fixedOffset: Vector2 = Vector2(0, -15)
@export var dirOffset: Vector2 = Vector2(0, 0)
@export var speed: Vector2 = Vector2(0.1, 0.25)
@onready var player: Node = get_parent()

var currentDirOffset = Vector2(dirOffset.x, dirOffset.y)

# Метод обновляет границы до которых может добраться камера, если клетка является
# "основной" для элемента атласа, до до нее доберется камера - иначе нет.
# Т.е. если есть спрайт на 4 плитки, то считаться может только нижний левый
# (по крайне мере у меня только так работает)
func updateCameraBorders() -> void:
	var visibleArea: Rect2i = tileMap.get_used_rect();
	var tileSize: int = tileMap.rendering_quadrant_size;
	var upperLeftCorner: Vector2i = visibleArea.position * tileSize;
	var lowerRightCorner: Vector2i = (visibleArea.position + visibleArea.size) * tileSize;
	
	limit_left = upperLeftCorner.x;
	limit_top = upperLeftCorner.y;
	limit_right = lowerRightCorner.x;
	limit_bottom = lowerRightCorner.y;

func _ready() -> void:
	updateCameraBorders() # todo fm почему границы ограничены постоянно при том, что _ready вызывалось 1 раз 

func _process(delta: float) -> void:
	# https://forum.godotengine.org/t/move-camera-to-mouse/12575/2
	# todo ue сделать чтобы камера могла двигаться только половину расстояния от длины экрана
	# т.е. чтобы камера не двигалась дальше половины расстояния между игроком и гранью экрана 
	var interpolate_val = 1
	var target = player.global_position 
	var mid_x = (target.x + get_global_mouse_position().x) / 2
	var mid_y = (target.y + get_global_mouse_position().y) / 2
	
	# todo bug сделать ограничение, чтобы мышку и игрока было видно на ЭКРАНЕ, если мышка за экраном, то ее положение не должно учитываться 
	global_position = global_position.lerp(Vector2(mid_x, mid_y), interpolate_val * delta) 

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#peekMouse(event)

#func peekMouse(mouseMotion: InputEvent):
	## Set the position of the camera
	#var myPosition: Vector2 = Vector2(0, 0)
	#var mousePosition: Vector2 = mouseMotion.position
	#var targetPosition: Vector2 = get_parent().global_position
#
	#myPosition.x = lerp(targetPosition.x, mousePosition.x, mouseMoveAmount.x)
	#myPosition.y = lerp(targetPosition.y, mousePosition.y, mouseMoveAmount.y)
	#var posX = 0
	#var posY = 0
	## Mouse Input
	#posX = lerp(position.x, myPosition.x + fixedOffset.x + currentDirOffset.x, speed.x)
	#posY = lerp(position.y, myPosition.y + fixedOffset.y + currentDirOffset.y, speed.y)
	## Apply the Camera's Position
	#if !ignoreX: position.x = posX
	#if !ignoreY: position.y = posY

# Камера двигается за мышкой до определенного порогового значения 
#func peekMouse(mouseMotion: InputEvent) -> void:
	## код для поддержки джойстика https://github.com/sventomasek/Godot-Scripts/blob/main/Camera.gd#L53
	#var target: Vector2 = mouseMotion.position - (position + get_viewport().size * 1.0) * 0.5
	#print("--------------------")
	#print("mouseMotion.position: " + str(mouseMotion.position))
	#print("get_viewport().size: " + str(get_viewport().size))
	#print("target: " + str(target.length()))
	#print("position: " + str(position))
	#if target.length() < deadZone:
		#position = get_parent().global_position
	#else:
		#print("target to deadZone diff: " + str((target.length() - deadZone) * 0.5))
		#position = target.normalized() * (target.length() - deadZone) * 0.5
	#print("position at the end: " + str(position))

#func _process(delta):
	#var player_pos: Vector2 = get_parent().global_position
#
	## Получаем позицию мыши относительно центра экрана
	#var mouse_pos = get_global_mouse_position() - get_viewport_rect().size / 2.0
#
	## Проверяем, находится ли мышь в пределах порога
	#if mouse_pos.length() > deadZone:
		## Вычисляем новую позицию камеры, чтобы следовать за мышью
		#global_position = player_pos + mouse_pos
	#else:
		## Камера остается на месте, так как мышь находится в пределах порога
		#global_position = player_pos
