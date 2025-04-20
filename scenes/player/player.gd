extends CharacterBody2D

class_name Player

var dropped_haul_scene = preload("res://scenes/dropped_haul/dropped_haul.tscn")

# Used when respawning
var initial_position: Vector2

###### STATS ######
## Stats might change from shop items or temporary boosts
## Weight
# how fat u r (in kg)
var player_weight = 10000.0
## Speed and acceleration
# max horizontal ground speed
var max_top_speed = 200.0
# lowest your top speed can be if you're overburdened
var min_top_speed = 75.0
# how much your top speed is lowered per kg of weight
var speed_penalty = 0.5
# acceleration (per physics frame)
var accel = 30.0
# acceleration in the air
var air_accel = 5.0
## Jumping
# instantaneous vertical velocity bonus when jumping off the ground at 0kg
var max_jump_velocity = 200.0
# lowest jump velocity can go to if you're overburdened
var min_jump_velocity = 150.0
# how much your jump velocity is lowered per kg of weight
var jump_velocity_penalty = 0.0
## Jetpack
# jetpack vertical acceleration at 0kg
var max_jetpack_accel = 40.0
# lowest jetpack accel can go to if you're overburdened
var min_jetpack_accel = 15.0
# how much your jetpack accel is lowered per kg of weight
var jetpack_accel_penalty = 0.0
# max upward speed
var max_jetpack_top_speed = 225.0
var min_jetpack_top_speed = 80.0
var jetpack_speed_penalty = 0.5
# gas tank size (in mL)
var fuel_capacity = 1000.0
# how much fuel the jetpack consumes (in mL per physics frame)
var jetpack_fuel_efficiency = 5.0
## Digging
# digging power (per physics frame)
# TODO: this should be 1.0 for real digging to return
var digging_power = 1000.0
var digging_heat_gen = 0.5
## Heat
# total heat value before it impacts digging
var heat_capacity = 200
var heat_decay_rate = 1.0
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
## Heat
# how hot ur shid is (in f)
var current_dig_heat = 0.0
## Haul
# value of current haul (in United States Dollars)
var haul_value = 0.0
# how heavy ur shid is (in kg)
var haul_weight = 0.0
## Bank
# value of sold items
var bank_value = 0.0
## Jetpack
var is_jetpacking = false
## Used by animations
var facing_right = true

func _ready():
  $AnimatedSprite2D.play()
  GameState.player = self
  initial_position = position

func _physics_process(delta):
  _process_movement(delta)
  _process_heat(delta)
  _process_digging(delta)
  _process_animation()

func _process_animation():
  if velocity == Vector2(0, 0):
    # idle
    $AnimatedSprite2D.speed_scale = 1.0
    if facing_right:
      $AnimatedSprite2D.animation = "idle_right"
    else:
      $AnimatedSprite2D.animation = "idle_left"
  else:
    # movin
    if is_on_floor():
      # ground
      $AnimatedSprite2D.speed_scale = 10.0
      if facing_right:
        $AnimatedSprite2D.animation = "walk_right"
      else:
        $AnimatedSprite2D.animation = "walk_left"
    else:
      # air
      if is_jetpacking:
        $AnimatedSprite2D.speed_scale = 2.0
        if !$JetPackSound.playing:
          $JetPackSound.play()
      else:
        # if not jetpacking, just freeze on first frame of air anim
        $AnimatedSprite2D.speed_scale = 0.0
        $AnimatedSprite2D.frame = 0
        $JetPackSound.stop()
      if facing_right:
        $AnimatedSprite2D.animation = "air_right"
      else:
        $AnimatedSprite2D.animation = "air_left"


func _process_movement(delta):
  if is_on_floor():
    # Ground stuff
    is_jetpacking = false
    # Handle jump
    if Input.is_action_just_pressed("jump"):
      velocity.y = get_jump_velocity() * -1
      $JetpackDelay.start()

    # Handle floor movement
    var move_direction = Input.get_axis("move_left", "move_right")
    if move_direction:
      facing_right = move_direction > 0
      velocity.x = move_toward(velocity.x, move_direction * get_top_speed(), accel)
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
      facing_right = move_direction > 0
      velocity.x = move_toward(velocity.x, move_direction * get_top_speed(), air_accel)
    else:
      velocity.x = move_toward(velocity.x, 0, air_accel)

    if Input.is_action_pressed("jump") && $JetpackDelay.is_stopped() && current_fuel > 0:
      is_jetpacking = true
      # jetpack go brrr
      velocity.y = move_toward(velocity.y, -get_jetpack_top_speed(), get_jetpack_accel())
      # consume fuel
      current_fuel -= jetpack_fuel_efficiency
      $JetpackExhaust.emitting = true
    else:
      is_jetpacking = false
      $JetpackExhaust.emitting = false

  move_and_slide()
  clamp_to_world()

func _process_heat(delta: float):
  if is_digging:
    current_dig_heat += digging_heat_gen
  elif current_dig_heat > 0:
    current_dig_heat -= heat_decay_rate
  elif current_dig_heat < 0:
    current_dig_heat = 0

func _process_digging(delta: float):
  var can_dig = get_total_heat() < heat_capacity

  if Input.is_action_pressed("primary_mouse_action") && can_dig:
    var new_digging_tile = get_targeted_tile()
    if !new_digging_tile.is_diggable():
      # if it's not diggable, don't start diggin
      clear_digging_state()
      return

    is_digging = true
    if !$DiggingSound.playing:
      $DiggingSound.play()
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
      # play sound
      $BreakSound.play()
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
  $DiggingSound.stop()
  is_digging = false
  current_digging_tile = null
  digging_progress = 0.0


func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("respawn"):
    respawn()

  var targeted_tile = get_targeted_tile()
  if targeted_tile.is_diggable():
    # show crosshair
    $HighlightedTile.visible = true
    $HighlightedTile.global_position = GameState.map_coords_to_global_position(targeted_tile.coords)
  else:
    # hide crosshair
    $HighlightedTile.visible = false


func get_targeted_tile() -> Tile:
  var mouse_global_pos = get_global_mouse_position()
  # closest tile in the direction of the mouse
  var closest_tile_global_pos = Vector2(
    move_toward(global_position.x, mouse_global_pos.x, Constants.TILE_WIDTH),
    move_toward(global_position.y, mouse_global_pos.y, Constants.TILE_WIDTH),
  )
  var hovered_tile_coords = GameState.global_position_to_map_coords(closest_tile_global_pos)
  return GameState.map[hovered_tile_coords]


func clamp_to_world():
  position = position.clamp(
    Vector2(0.0, 0.0),
    Vector2(Constants.MAX_WORLD_WIDTH * Constants.TILE_WIDTH, Constants.MAX_GEN_DEPTH * Constants.TILE_WIDTH)
  )

func get_ambient_heat() -> float:
  return GameState.global_position_to_map_coords(get_global_position()).y

func get_total_heat() -> float:
  return get_ambient_heat() + current_dig_heat

func get_total_weight() -> float:
  return player_weight + haul_weight + (current_fuel / 1000)

func add_to_haul(tile: Tile):
  haul_weight += current_digging_tile.weight()
  haul_value += current_digging_tile.value()

func get_top_speed() -> float:
  return max(max_top_speed - get_total_weight() * speed_penalty, min_top_speed)

func get_jump_velocity() -> float:
  return max(max_jump_velocity - get_total_weight() * jump_velocity_penalty, min_jump_velocity)

func get_jetpack_top_speed() -> float:
  return max(max_jetpack_top_speed - get_total_weight() * jetpack_speed_penalty, min_jetpack_top_speed)

func get_jetpack_accel() -> float:
  return max(max_jetpack_accel - get_total_weight() * jetpack_accel_penalty, min_jetpack_accel)

func refuel():
  if current_fuel < fuel_capacity:
    $RefuelSound.play()
    current_fuel = fuel_capacity

func sell_haul():
  bank_value += haul_value
  haul_value = 0.0
  haul_weight = 0.0

func respawn():
  # create haul drop
  if haul_weight > 0.0 || haul_value > 0.0:
    var haul_instance = dropped_haul_scene.instantiate()
    haul_instance.haul_value = haul_value
    haul_instance.haul_weight = haul_weight
    haul_instance.position = position
    add_sibling(haul_instance)
    # clear ur haul
    haul_weight = 0.0
    haul_value = 0.0
  # tp to start and refuel
  position = initial_position
  velocity = Vector2.ZERO
  refuel()
