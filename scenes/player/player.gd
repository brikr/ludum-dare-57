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


func _physics_process(delta):
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

func _process(delta: float) -> void:
  if Input.is_action_pressed("primary_mouse_action"):
    pass
