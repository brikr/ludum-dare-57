extends Node2D

func _ready():
  # make the skybox match the width of the generated world
  $Sky.size.x = Constants.MAX_WORLD_WIDTH * Constants.TILE_WIDTH

  # noise gen testing pls to remove
  var noise = FastNoiseLite.new() # there are a shit load of props you can change
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
  noise.seed = 69 # kek, funny numbie
  noise.fractal_octaves = 5
  noise.fractal_gain = 10

  var image = noise.get_image(Constants.MAX_WORLD_WIDTH, 20)

  $test.texture = ImageTexture.create_from_image(image)

func _process(_delta):
  if Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()
