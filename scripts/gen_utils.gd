class_name GenUtils

static func get_noise():
  var noise = FastNoiseLite.new() # there are a shit load of props you can change
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
  noise.seed = randi()
  noise.frequency = 0.3
  noise.fractal_octaves = 2
  noise.fractal_gain = 0.4
  noise.fractal_lacunarity = 2.5
  return noise
