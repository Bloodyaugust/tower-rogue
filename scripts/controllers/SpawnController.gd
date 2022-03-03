extends Node2D

const _creature_scene:PackedScene = preload("res://actors/Creature.tscn")

func _spawn_loop() -> void:
  _spawn_creature(Depot.get_line("creatures", "orc"))
  await get_tree().create_timer(2.5).timeout
  _spawn_loop()

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

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.SPAWN_CREATURE:
      get_tree().get_root().add_child(command_data.creature)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_STARTING:
          _spawn_loop()

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
  CommandQueue.command_do.connect(_on_command_do)
