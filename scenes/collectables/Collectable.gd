extends Area2D

# создаем inhereted scene
# если нужно переопределить скрипт, то расширяем (extends) НОВЫЙ 
# скрипт от скрипта родителя (можно ctrl + перенос)
const type_name: String = "Collectable"

func collect() -> void:
	queue_free()

func check_type(type: String) -> bool:
	return type_name == type
