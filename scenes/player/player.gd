extends CharacterBody2D

# max horizontal ground speed
var speed = 150.0
# acceleration (per physics frame)
var accel = 30.0
# acceleration in the air
var air_accel = 5.0
# instantaneous vertical velocity bonus when jumping off the ground
var jump_velocity = 300.0
# jetpack vertical acceleration
var jetpack_accel = 30.0
# max upward speed
var jetpack_speed_limit = 175.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# max fall speed
var terminal_velocity = 350.0
# digging power (per physics frame)
var digging_power = 1.0

# digging state
var is_digging = false
var current_digging_tile: Tile
# amount of power expended on current tile
var digging_progress = 0.0

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
      velocity.y = jump_velocity * -1
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

    if Input.is_action_pressed("jump") and $JetpackDelay.is_stopped():
      # jetpack go brrr
      velocity.y -= jetpack_accel
      # limit jetpack boosties
      velocity.y = max(velocity.y, -jetpack_speed_limit)

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
      GameState.dig(current_digging_tile.coords)
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
