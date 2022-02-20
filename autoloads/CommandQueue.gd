extends Node

enum COMMAND_TYPES {
  BUILD_TOWER
}

signal command_do(command_data:Dictionary)
signal command_undo(command_data:Dictionary)

var queue:Array

func add_command(command_data:Dictionary) -> void:
  queue.append(command_data)
  command_do.emit(command_data)
  
func undo() -> void:
  if queue.size() > 0:
    command_undo.emit(queue.pop_back())

func _unhandled_input(event) -> void:
  if event.is_action_pressed("ui_undo"):
    undo()
