extends Control

@onready var _next_wave:Button = find_node("NextWave")

func _on_next_wave_pressed() -> void:
  Store.set_state("wave", Store.state.wave + 1)

func _ready() -> void:
  _next_wave.pressed.connect(_on_next_wave_pressed)
