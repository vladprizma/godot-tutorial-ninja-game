extends HBoxContainer

@onready var heartGuiClass: Resource = preload("res://scenes/hud/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setMaxHearts(maxHearts: int) -> void:
	for i in range(maxHearts):
		var heart: Panel = heartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int) -> void:
	var hearts: Array[Node] = get_children()
	
	for i in range(currentHealth):
		hearts[i].update(true)
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false) # todo ue если попадать под атаку противника слишком часто, то тут возникает исключение
