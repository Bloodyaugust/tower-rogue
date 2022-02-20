extends Node

static func centroid(points:Array) -> Vector2:
  var _centroid:Vector2 = Vector2.ZERO

  if points.size() == 0:
    return _centroid

  for _point in points:
    _centroid += _point

  _centroid = _centroid / float(points.size())

  return _centroid

static func find_array_indices(array:Array, callable:Callable) -> Array:
  var _indices:Array = []
  var _index:int = 0
  
  for _item in array:
    if callable.call(_item):
      _indices.append(_index)
    
    _index += 1
    
  return _indices

static func free_children(node):
  for n in node.get_children():
      n.free()

static func queue_free_children(node):
  for n in node.get_children():
      n.queue_free()

static func reference_safe(node:Variant) -> bool:
  return node != null && node is Node && !node.is_queued_for_deletion() && is_instance_valid(node)

static func tilemap_global_cell_position(tilemap: TileMap, position: Vector2) -> Vector2:
  return tilemap.to_global(tilemap.map_to_world(tilemap.world_to_map(tilemap.to_local(position))))
