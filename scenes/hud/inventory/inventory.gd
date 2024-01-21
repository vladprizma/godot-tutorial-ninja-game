extends Control

var isOpen: bool

func open() -> void:
	visible = true
	isOpen = true

func close() -> void:
	visible = false
	isOpen = false
