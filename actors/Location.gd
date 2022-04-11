extends Node2D

const ACTIVE_COLOR:Color = Color.GREEN

@onready var _sprite:Sprite2D = find_node("Sprite2D")

func set_active_location() -> void:
  _sprite.modulate = ACTIVE_COLOR
