extends Node2D

const _tower_scene:PackedScene = preload("res://actors/Tower.tscn")
const _building_preview_scene:PackedScene = preload("res://doodads/BuildingPlacementPreview.tscn")
const _building_allowed_modulate:Color = Color(1.0, 1.0, 1.0, 0.2)
const _building_not_allowed_modulate:Color = Color(0.8, 0.2, 0.2, 0.2)
const _tile_map_scene:PackedScene = preload("res://actors/TileMap.tscn")

@onready var _building_preview:Sprite2D = Sprite2D.new()

var _tile_map:TileMap

func _can_build_tower() -> bool:
  if Store.state.money < Store.state.tower_building_selection.cost:
    return false

  var _space = get_world_2d().direct_space_state
  var _intersect_point_params:PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
  _intersect_point_params.position = get_global_mouse_position()
  _intersect_point_params.collide_with_areas = true
  
  return _space.intersect_point(_intersect_point_params, 1).size() == 0

func _initialize() -> void:
  _building_preview = _building_preview_scene.instantiate()

  get_tree().get_root().add_child(_building_preview)

  _tile_map = _tile_map_scene.instantiate()

  get_tree().get_root().add_child(_tile_map)
  
  Store.set_state("tower_selection", null)
  Store.set_state("tower_building_selection", null)

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.BUILD_TOWER:
      Store.set_state("money", Store.state.money - command_data.tower.data.cost)
      _tile_map.add_child(command_data.tower)

func _on_command_undo(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.BUILD_TOWER:
      Store.set_state("money", Store.state.money + command_data.tower.data.cost)
      command_data.tower.queue_free()

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "tower_selection":
      if substate:
        Store.set_state("tower_building_selection", null)
    "tower_building_selection":
      if substate:
        _building_preview.visible = true
        _building_preview.texture = load("res://sprites/towers/" + substate.id + ".png")
      else:
        _building_preview.visible = false

func _process(delta):
  if Store.state.tower_building_selection:
    _building_preview.global_position = GDUtil.tilemap_global_cell_position(_tile_map, get_global_mouse_position())

    if _can_build_tower():
      _building_preview.modulate = _building_allowed_modulate
    else:
      _building_preview.modulate = _building_not_allowed_modulate

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
  CommandQueue.command_do.connect(_on_command_do)
  CommandQueue.command_undo.connect(_on_command_undo)

  call_deferred("_initialize")

func _unhandled_input(event):
  if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
    if Store.state.tower_building_selection:
      Store.set_state("tower_building_selection", null)
    if Store.state.tower_selection:
      Store.set_state("tower_selection", null)

  if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
    if Store.state.tower_building_selection:
      if _can_build_tower():
        var _new_tower = _tower_scene.instantiate()
        _new_tower.global_position = GDUtil.tilemap_global_cell_position(_tile_map, get_global_mouse_position())
        _new_tower.data = Store.state.tower_building_selection

        CommandQueue.add_command({
          "type": CommandQueue.COMMAND_TYPES.BUILD_TOWER,
          "tower": _new_tower
        })
