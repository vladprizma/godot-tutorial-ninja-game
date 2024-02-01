extends Node2D

@onready var heartsContainer: HBoxContainer = $CanvasLayer/HeartsContainer
@onready var player: CharacterBody2D = $Player

const SLIME = preload("res://scenes/enemies/slime.tscn")

func _ready() -> void:
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	

func spawn_enemy():
	var new_enemy: Node = SLIME.instantiate()
	var spawn_point: PathFollow2D = %SpawnPoint
	spawn_point.progress_ratio = randf()
	new_enemy.global_position = spawn_point.global_position
	add_child(new_enemy)

func _on_spawn_cooldown_timeout() -> void:
	spawn_enemy()
