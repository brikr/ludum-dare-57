extends CanvasLayer

var item_button_scene = preload("res://scenes/shop_ui/item_button.tscn")

const ITEM_BUTTON_TEMPLATE = "%s ($%d)"

# TODO
# - disable items u cant afford
# - take money when buying
# - remove button after buying

func _ready():
  print("rdy")
  for item in Items.GEAR_REGISTRY:
    var instance = item_button_scene.instantiate()
    instance.text = ITEM_BUTTON_TEMPLATE % [item.name, item.price]
    instance.pressed.connect(buy_item.bind(item))
    $GearContainer.add_child(instance)

func buy_item(item: Item):
  print("buying ", item.name)
  item.apply()
