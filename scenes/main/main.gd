extends Node2D

var gonster_scene = preload("res://scenes/gonster/gonster.tscn")

func _ready():
  place_gonster()

func test_image():
  var image = GenUtils.get_chasm_noise().get_image(Constants.MAX_WORLD_WIDTH, 100)
  $test.texture = ImageTexture.create_from_image(image)

func place_gonster():
  var gonster_instance = gonster_scene.instantiate()
  gonster_instance.position = GameState.gonster_init_position
  add_child(gonster_instance)
