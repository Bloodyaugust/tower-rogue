extends Node2D

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
   "health":
     if substate <= 0:
      Store.set_state("game", GameConstants.GAME_OVER)
      Store.set_state("wave", 0)
      Store.set_state("health", 10)

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
