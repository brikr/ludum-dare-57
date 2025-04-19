extends CharacterBody2D

var speed = 150.0
var accel = 30.0
var air_accel = 5.0
var jump_velocity = 310.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
  if is_on_floor():
    # Ground stuff
    # Handle jump
    if Input.is_action_just_pressed("jump"):
      velocity.y = jump_velocity * -1

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
    # Handle air movement
    var move_direction = Input.get_axis("move_left", "move_right")
    if move_direction:
      velocity.x = move_toward(velocity.x, move_direction * speed, air_accel)
    else:
      velocity.x = move_toward(velocity.x, 0, air_accel)


  move_and_slide()
