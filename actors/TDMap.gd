extends TileMap

@onready var _path_cells:Array = get_used_cells(1)
@onready var _terrain_cells:Array = get_used_cells(0)

func is_tile_buildable(global_position:Vector2) -> bool:
  var _testing_cell = Vector2i(world_to_map(to_local(global_position)))

  for _cell in _path_cells:
    if _cell == _testing_cell:
      return false
      
  for _cell in _terrain_cells:
    if _cell == _testing_cell:
      return true
      
  return false
