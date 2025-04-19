class_name GenUtils

static func get_noise():
  var noise = FastNoiseLite.new() # there are a shit load of props you can change
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
  noise.seed = 69 # kek, funny numbie
  noise.fractal_octaves = 5
  noise.fractal_gain = 10
  return noise
