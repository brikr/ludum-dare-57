extends CanvasLayer

var item_button_scene = preload("res://scenes/shop_ui/item_button.tscn")

const ITEM_BUTTON_TEMPLATE = "%s ($%d)"

# item name -> button for buying item
var buttons: Dictionary[String, Button]

func _ready():
  # Create a button for every item, but don't show them
  for item in Items.GEAR_REGISTRY:
    var instance = item_button_scene.instantiate()
    instance.text = ITEM_BUTTON_TEMPLATE % [item.name, item.price]
    instance.item = item
    instance.pressed.connect(item_button_pressed.bind(instance))
    instance.visible = false
    $GearContainer.add_child(instance)
    buttons[item.name] = instance

func get_items_to_show():
  var items_to_show: Array[String] = []
  for category in Item.Category.values():
    # Find the first item in the registry with that category that the player has not purchased
    var item_idx = Items.GEAR_REGISTRY.find_custom(func(item):
      return item.category == category && !GameState.purchased_items.has(item.name)
    )
    if item_idx >= 0:
      items_to_show.append(Items.GEAR_REGISTRY[item_idx].name)
  return items_to_show

func update_button_states():
  # Disable buttons for items you can't afford, and only show the first item of each category that hasn't been purchased
  var items_to_show = get_items_to_show()
  for itemName in buttons:
    buttons[itemName].disabled = GameState.player.bank_value < buttons[itemName].item.price
    buttons[itemName].visible = items_to_show.has(itemName)

  if items_to_show.is_empty():
    $AllItemsPurchased.visible = true

func item_button_pressed(button: ItemButton):
  GameState.purchased_items.append(button.item.name)
  GameState.player.bank_value -= button.item.price
  button.item.apply()
  button.queue_free()
  buttons.erase(button.item.name)
  update_button_states()
