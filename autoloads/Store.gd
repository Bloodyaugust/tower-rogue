extends Node

signal generate_overworld()
signal state_changed(state_key, substate)

var persistent_store:PersistentStore
var state: Dictionary = {
  "debug": false,
  "client_view": "",
  "game": "",
  "tower_selection": null,
  "tower_building_selection": null,
  "money": 0,
  "wave": -1,
  "health": 0,
  "spawning": false
 }

func start_game() -> void:
  set_state("client_view", ClientConstants.CLIENT_VIEW_NONE)
  set_state("tower_selection", null)
  set_state("tower_building_selection", null)
  set_state("money", 100)
  set_state("health", 10)
  set_state("game", GameConstants.GAME_IN_PROGRESS)
  set_state("wave", 0)

func save_persistent_store() -> void:
  if ResourceSaver.save(ClientConstants.CLIENT_PERSISTENT_STORE_PATH, persistent_store) != OK:
    print("Failed to save persistent store")

func set_state(state_key: String, new_state) -> void:
  state[state_key] = new_state
  emit_signal("state_changed", state_key, state[state_key])
  print("State changed: ", state_key, " -> ", state[state_key])
  
func _initialize():
  set_state("client_view", ClientConstants.CLIENT_VIEW_SPLASH)
  set_state("game", GameConstants.GAME_OVER)
  set_state("tower_selection", null)
  set_state("tower_building_selection", null)
  set_state("money", 100)
  set_state("wave", -1)
  set_state("health", 0)

func _ready():
  if Directory.new().file_exists(ClientConstants.CLIENT_PERSISTENT_STORE_PATH):
    persistent_store = load(ClientConstants.CLIENT_PERSISTENT_STORE_PATH)

  if !persistent_store:
    persistent_store = PersistentStore.new()
    save_persistent_store()

  call_deferred("_initialize")
