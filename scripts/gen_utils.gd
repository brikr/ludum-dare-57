class_name GenUtils

static func get_noise():
  var noise = FastNoiseLite.new() # there are a shit load of props you can change
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
  noise.seed = randi()
  noise.frequency = 0.15
  noise.fractal_octaves = 2
  noise.fractal_gain = 0.4
  noise.fractal_lacunarity = 2.5
  return noise

static func get_chasm_noise():
  var noise = FastNoiseLite.new()
  noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
  noise.seed = randi()
  noise.frequency = 0.045
  noise.fractal_octaves = 3
  noise.fractal_gain = 0.4
  noise.fractal_lacunarity = 2.0
  return noise

static func generate_with_depth_probability(
    source_data: Dictionary,
    key,
    min_y: int,
    max_y: int,
    noise_func := func(coords: Vector2i) -> float:
        return randf(), # default fallback
    apply_func := func(coords: Vector2i, probability: float) -> void:
        pass
):
    var min_depth = source_data[key][Constants.WORLD_GEN_FIELDS.MIN_DEPTH]
    var max_depth = source_data[key][Constants.WORLD_GEN_FIELDS.MAX_DEPTH]
    var min_depth_coefficient = source_data[key][Constants.WORLD_GEN_FIELDS.MIN_COEFFICIENT]
    var max_depth_coefficient = source_data[key][Constants.WORLD_GEN_FIELDS.MAX_COEFFICIENT]
    var threshold = source_data[key][Constants.WORLD_GEN_FIELDS.THRESHOLD]

    for x in Constants.MAX_WORLD_WIDTH:
        for y in range(min_y, max_y):
            var coords := Vector2i(x, y)
            var probability := 0.0

            if y > min_depth and y < max_depth:
                 # How far are we from min -> max depth (normalized 0.0 to 1.0)
                var depth_ratio = float(y - (Constants.SURFACE_HEIGHT + min_depth)) / float(max_depth - (Constants.SURFACE_HEIGHT + min_depth))
                # Sweep coefficient based on depth.
                var depth_coefficient = lerp(min_depth_coefficient, max_depth_coefficient, depth_ratio)

                var rand_val = noise_func.call(coords)
                probability = rand_val * depth_coefficient

            apply_func.call(coords, probability)
