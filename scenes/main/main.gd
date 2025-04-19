extends Node2D

func _ready():
  pass

func test_image():
  var image = GenUtils.get_noise().get_image(Constants.MAX_WORLD_WIDTH, 20)
  $test.texture = ImageTexture.create_from_image(image)

func _process(_delta):
  if Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()
