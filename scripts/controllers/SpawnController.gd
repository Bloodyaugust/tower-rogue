extends Node2D

const SPAWN_INTERVAL:float = 0.5

const _creature_scene:PackedScene = preload("res://actors/Creature.tscn")

var _spawns_left:int = 0
var _time_to_spawn:float = 0.0

func _spawn_creature(creature_data:Dictionary) -> void:
  var _new_creature:Node2D = _creature_scene.instantiate()
  var _path:PathFollow2D = get_tree().get_nodes_in_group("paths")[0]
      
  _new_creature.data = creature_data
  _new_creature.path = _path
  _path.offset = 0
  _new_creature.global_position = _path.global_position
  CommandQueue.add_command({
    "type": CommandQueue.COMMAND_TYPES.SPAWN_CREATURE,
    "creature": _new_creature
  })

func _start_wave() -> void:
  _spawns_left = int(get_tree().get_nodes_in_group("tdmaps")[0].get_difficulty())
  _time_to_spawn = 0.0
  Store.set_state("spawning", true)

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.SPAWN_CREATURE:
      get_tree().get_root().add_child(command_data.creature)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "wave":
      if Store.state.game == GameConstants.GAME_IN_PROGRESS:
        _start_wave()
    "game":
      match substate:
        GameConstants.GAME_OVER:
          Store.set_state("spawning", false)
          for _creature in get_tree().get_nodes_in_group("creatures"):
            _creature.queue_free()

func _process(delta):
  if Store.state.spawning:
    _time_to_spawn = clampf(_time_to_spawn - delta, 0, SPAWN_INTERVAL)

    if _time_to_spawn == 0 && _spawns_left > 0:
      _spawn_creature(Depot.get_line("creatures", "orc"))
      _time_to_spawn = SPAWN_INTERVAL
      _spawns_left -= 1
      
    if _spawns_left == 0:
      Store.set_state("spawning", false) 

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
  CommandQueue.command_do.connect(_on_command_do)
