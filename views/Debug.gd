extends Control

@onready var _next_wave:Button = find_node("NextWave")

func _on_next_wave_pressed() -> void:
  Store.set_state("wave", Store.state.wave + 1)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "debug":
      visible = substate

func _ready() -> void:
  Store.state_changed.connect(_on_store_state_changed)
  _next_wave.pressed.connect(_on_next_wave_pressed)
  
  visible = false

func _unhandled_input(event) -> void:
  if event.is_action_pressed("debug"):
    Store.set_state("debug", !Store.state.debug)
