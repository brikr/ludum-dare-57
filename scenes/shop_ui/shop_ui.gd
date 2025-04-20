extends CanvasLayer

var item_button_scene = preload("res://scenes/shop_ui/item_button.tscn")

const ITEM_BUTTON_TEMPLATE = "%s ($%d)"

# item name -> button for buying item
var buttons: Dictionary[String, Button]

func _ready():
  for item in Items.GEAR_REGISTRY:
    var instance = item_button_scene.instantiate()
    instance.text = ITEM_BUTTON_TEMPLATE % [item.name, item.price]
    instance.item = item
    instance.pressed.connect(item_button_pressed.bind(instance))
    $GearContainer.add_child(instance)
    buttons[item.name] = instance

func update_button_states():
  for itemName in buttons:
    buttons[itemName].disabled = GameState.player.bank_value < buttons[itemName].item.price

func item_button_pressed(button: ItemButton):
  GameState.player.bank_value -= button.item.price
  button.item.apply()
  button.queue_free()
  buttons.erase(button.item.name)
