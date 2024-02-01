extends "res://scenes/collectables/projectiles/projectile.gd"

@onready var spin_animation: AnimationPlayer = $SpinAnimation

func _ready() -> void:
	spin_animation.play("spin")
	super._ready()
