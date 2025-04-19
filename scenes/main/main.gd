extends Node

func _ready():
  # make the skybox match the width of the generated world
  $Sky.size.x = Constants.MAX_WORLD_WIDTH * Constants.TILE_WIDTH

func _process(_delta):
  if Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()
