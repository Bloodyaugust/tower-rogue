extends Node2D

const LOCATION_SCENE:PackedScene = preload("res://actors/Location.tscn")

@onready var _locations:Node2D = find_node("Locations")
@onready var _preview:Sprite2D = find_node("Preview")

func generate_overworld() -> void:
  var _texture = ImageTexture.new()
  var _noise = OpenSimplexNoise.new()
  print("generating overworld")
  
  GDUtil.queue_free_children(_locations)

  # Configure
  _noise.seed = randi()
  _noise.octaves = 4
  _noise.period = 20.0
  _noise.persistence = 0.8
  
  _texture.create_from_image(_noise.get_image(960, 960))
  _preview.texture = _texture
  
  const overworld_points:Array = [
    Vector2(-480, -480),
    Vector2(-240, -480),
    Vector2(0, -480),
    Vector2(240, -480),
    Vector2(480, -480),
    Vector2(-480, -240),
    Vector2(-240, -240),
    Vector2(0, -240),
    Vector2(240, -240),
    Vector2(480, -240),
    Vector2(-480, 0),
    Vector2(-240, 0),
    Vector2(0, 0),
    Vector2(240, 0),
    Vector2(480, 0),
    Vector2(-480, 240),
    Vector2(-240, 240),
    Vector2(0, 240),
    Vector2(240, 240),
    Vector2(480, 240),
    Vector2(-480, 480),
    Vector2(-240, 480),
    Vector2(0, 480),
    Vector2(240, 480),
    Vector2(480, 480),
  ]
  
  for _point in overworld_points:
    var _value = abs(_noise.get_noise_2dv(_point))
    var _new_location:Node2D = LOCATION_SCENE.instantiate()
    _new_location.global_position = _point
    _locations.add_child(_new_location)
    print(_value)
    
    if _value >= 0.2:
      _new_location.set_active_location()

# Called when the node enters the scene tree for the first time.
func _ready():
  Store.generate_overworld.connect(generate_overworld)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
