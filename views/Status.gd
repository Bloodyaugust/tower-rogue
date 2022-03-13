extends Container

@onready var _health:Label = find_node("Health")
@onready var _money:Label = find_node("Money")
@onready var _next_wave:Button = find_node("NextWave")
@onready var _wave:Label = find_node("Wave")

func _on_next_wave_pressed() -> void:
  Store.set_state("wave", Store.state.wave + 1)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "health":
      _health.text = "Health:  %d" % substate
    "money":
      _money.text = "Money:  %06d" % substate
    "wave":
      _wave.text = "Wave:  %d" % substate
    "spawning":
      _next_wave.disabled = substate
    "game":
      match substate:
        GameConstants.GAME_IN_PROGRESS:
          _next_wave.disabled = false
        GameConstants.GAME_OVER:
          _next_wave.disabled = true

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
  _next_wave.pressed.connect(_on_next_wave_pressed)
  
  _health.text = "Health: %d" % Store.state.health
  _money.text = "Money:  %06d" % Store.state.money
  _wave.text = "Wave:  %d" % Store.state.wave
