extends Control

@onready var _next_wave:Button = find_node("NextWave")
@onready var _start_game:Button = find_node("StartGame")

func _on_next_wave_pressed() -> void:
  Store.set_state("wave", Store.state.wave + 1)

func _on_start_game_pressed() -> void:
  Store.start_game()

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "debug":
      visible = substate
    "spawning":
      _next_wave.disabled = substate
    "game":
      match substate:
        GameConstants.GAME_IN_PROGRESS:
          _start_game.disabled = true
          _next_wave.disabled = false
        GameConstants.GAME_OVER:
          _next_wave.disabled = true
          _start_game.disabled = false

func _ready() -> void:
  Store.state_changed.connect(_on_store_state_changed)
  _next_wave.pressed.connect(_on_next_wave_pressed)
  _start_game.pressed.connect(_on_start_game_pressed)
  
  visible = false

func _unhandled_input(event) -> void:
  if event.is_action_pressed("debug"):
    Store.set_state("debug", !Store.state.debug)
