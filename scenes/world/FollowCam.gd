extends Camera2D

@export var tileMap: TileMap

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateCameraBorders()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
