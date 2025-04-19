extends CanvasLayer

func _ready():
  for item in Items.GEAR_REGISTRY:
    print(item.name)
