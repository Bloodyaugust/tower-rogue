extends Node

enum COMMAND_TYPES {
  BUILD_TOWER,
  SPAWN_CREATURE,
  ATTACK
}

signal command_do(command_data:Dictionary)
signal command_undo(command_data:Dictionary)

const max_queue_size:int = 1000

var queue:Array

func add_command(command_data:Dictionary) -> void:
  if queue.size() < max_queue_size:
    queue.pop_back()

  queue.append(command_data)
  command_do.emit(command_data)
  
func undo() -> void:
  if queue.size() > 0:
    command_undo.emit(queue.pop_back())
    
func undo_type(type:COMMAND_TYPES) -> void:
  var _matching_indices:Array = GDUtil.find_array_indices(queue, func(command): return command.type == type)
  var _removing_index:int = _matching_indices[_matching_indices.size() - 1] if _matching_indices.size() else -1
  
  if _removing_index > -1:
    command_undo.emit(queue[_removing_index])
    queue.remove_at(_removing_index)

func _unhandled_input(event) -> void:
  if event.is_action_pressed("ui_undo"):
    undo_type(COMMAND_TYPES.BUILD_TOWER)
