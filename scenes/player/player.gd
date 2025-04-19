extends CharacterBody2D

###### STATS ######
## Stats might change from shop items or temporary boosts
## Weight
# how fat u r (in kg)
var player_weight = 100.0
## Speed and acceleration
# max horizontal ground speed
var speed = 150.0
# acceleration (per physics frame)
var accel = 30.0
# acceleration in the air
var air_accel = 5.0
## Jumping
# instantaneous vertical velocity bonus when jumping off the ground at 0kg
var max_jump_velocity = 400.0
# lowest jump velocity can go to if you're overburdened
var min_jump_velocity = 150.0
# how much your jump velocity is lowered per kg of weight
var jump_velocity_penalty = 1.0
## Jetpack
# jetpack vertical acceleration at 0kg
var max_jetpack_accel = 40.0
# lowest jetpack accel can go to if you're overburdened
var min_jetpack_accel = 15.0
# how much your jetpack accel is lowered per kg of weight
var jetpack_accel_penalty = 0.1
# max upward speed
var jetpack_speed_limit = 175.0
# gas tank size (in mL)
var fuel_capacity = 3000.0
# how much fuel the jetpack consumes (in mL per physics frame)
var jetpack_fuel_efficiency = 5.0
## Digging
# digging power (per physics frame)
# TODO: this should be 1.0 for real digging to return
var digging_power = 1.0
## Falling
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# max fall speed
var terminal_velocity = 350.0

###### STATE ######
## State changes constantly as you are performing actions
## Digging
var is_digging = false
var current_digging_tile: Tile
# amount of power expended on current tile
var digging_progress = 0.0
## Fuel
var current_fuel = fuel_capacity
## Haul
# value of haul (in United States Dollars)
var haul_value = 0.0
# how heavy ur shid is (in kg)
var haul_weight = 0.0

func _ready():
  # set camera limits to generated world
  $Camera2D.limit_left = 0.0
  $Camera2D.limit_right = Constants.MAX_WORLD_WIDTH * Constants.TILE_WIDTH
  $Camera2D.limit_top = 0.0
  $Camera2D.limit_bottom = Constants.MAX_GEN_DEPTH * Constants.TILE_WIDTH


func _physics_process(delta):
  _process_movement(delta)
  _process_digging(delta)

func _process_movement(delta):
  if is_on_floor():
    # Ground stuff
    # Handle jump
    if Input.is_action_just_pressed("jump"):
      velocity.y = get_jump_velocity() * -1
      $JetpackDelay.start()

    # Handle floor movement
    var move_direction = Input.get_axis("move_left", "move_right")
    if move_direction:
      velocity.x = move_toward(velocity.x, move_direction * speed, accel)
    else:
      velocity.x = move_toward(velocity.x, 0, accel)
  else:
    # Air stuff
    # Apply gravity
    velocity.y += gravity * delta
    # limit fall speed
    velocity.y = min(velocity.y, terminal_velocity)
    # Handle air movement
    var move_direction = Input.get_axis("move_left", "move_right")
    if move_direction:
      velocity.x = move_toward(velocity.x, move_direction * speed, air_accel)
    else:
      velocity.x = move_toward(velocity.x, 0, air_accel)

    if Input.is_action_pressed("jump") && $JetpackDelay.is_stopped() && current_fuel > 0:
      # jetpack go brrr
      velocity.y = move_toward(velocity.y, -jetpack_speed_limit, get_jetpack_accel())
      # consume fuel
      current_fuel -= jetpack_fuel_efficiency

  move_and_slide()
  clamp_to_world()


func _process_digging(delta: float):
  if Input.is_action_pressed("primary_mouse_action"):
    var new_digging_tile_coords = GameState.global_position_to_map_coords(get_global_mouse_position())
    var new_digging_tile = GameState.map[new_digging_tile_coords]
    if !new_digging_tile.is_diggable():
      # if it's not diggable, don't start diggin
      clear_digging_state()
      return

    var is_digging = true
    $HighlightedTile/TileBreaking.visible = true
    # if we're digging a different tile than before, reset progress
    if new_digging_tile != current_digging_tile:
      current_digging_tile = new_digging_tile
      digging_progress = 0.0

    # advance digging progress
    digging_progress += digging_power
    # update tile breaking animation frame
    var tile_break_frame = floor(lerp(0, Constants.TILE_BREAKING_FRAME_COUNT, digging_progress / current_digging_tile.difficulty()))
    $HighlightedTile/TileBreaking.frame = tile_break_frame

    # if our current progress exceeds the tile's difficulty, blow it up
    if digging_progress >= current_digging_tile.difficulty():
      # collect resources
      add_to_haul(current_digging_tile)
      # belete tile
      GameState.dig(current_digging_tile.coords)
      # cease digging
      clear_digging_state()
  else:
    clear_digging_state()


func clear_digging_state():
  $HighlightedTile/TileBreaking.visible = false
  is_digging = false
  current_digging_tile = null
  digging_progress = 0.0


func _process(_delta: float) -> void:
  # Update highlighted tile position
  var mouse_pos = get_global_mouse_position()
  $HighlightedTile.global_position = Vector2(
    floor(mouse_pos.x / Constants.TILE_WIDTH) * Constants.TILE_WIDTH,
    floor(mouse_pos.y / Constants.TILE_WIDTH) * Constants.TILE_WIDTH,
  )


func clamp_to_world():
  position = position.clamp(
    Vector2(0.0, 0.0),
    Vector2(Constants.MAX_WORLD_WIDTH * Constants.TILE_WIDTH, Constants.MAX_GEN_DEPTH * Constants.TILE_WIDTH)
  )

func get_total_weight():
  return player_weight + haul_weight + (current_fuel / 1000)

func add_to_haul(tile: Tile):
  haul_weight += current_digging_tile.weight()
  haul_value += current_digging_tile.value()

func get_jump_velocity():
  return max(max_jump_velocity - get_total_weight() * jump_velocity_penalty, min_jump_velocity)

func get_jetpack_accel():
  return max(max_jetpack_accel - get_total_weight() * jetpack_accel_penalty, min_jetpack_accel)
