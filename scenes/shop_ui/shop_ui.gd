extends CanvasLayer

var item_button_scene = preload("res://scenes/shop_ui/item_button.tscn")

const ITEM_BUTTON_TEMPLATE = "%s ($%d)"

var buttons: Array[Button]
# TODO
# - disable items u cant afford
# - take money when buying
# - remove button after buying

func _ready():
  for item in Items.GEAR_REGISTRY:
    var instance = item_button_scene.instantiate()
    instance.text = ITEM_BUTTON_TEMPLATE % [item.name, item.price]
    instance.item = item
    instance.pressed.connect(item_button_pressed.bind(instance))
    $GearContainer.add_child(instance)
    buttons.append(instance)

func update_button_states():
  for button in buttons:
    button.disabled = GameState.player.bank_value < button.item.price

func item_button_pressed(button: ItemButton):
  GameState.player.bank_value -= button.item.price
  button.item.apply()
  button.queue_free()
