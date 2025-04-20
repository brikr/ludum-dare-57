extends CanvasLayer

const FUEL_WEIGHT_MONEY_TEMPLATE := """Fuel: [code]%.2fL[/code]
Drill Heat: [code]%03dC[/code]
Weight: [code]%dkg[/code]
Money: [code]$%d[/code]"""
const CURRENT_HAUL_VALUE_TEMPLATE := "Current haul: [code]$%d[/code]"

# stored on node so we can recolor it based on its value
var heat_fill_style = get_base_stylebox()
const HEAT_GRADIENT_DATA := {
  0.0: Color("#639bff"),
  0.6: Color("#639bff"),
  0.8: Color("#df7126"),
  1.0: Color("#ac3232")
}
var heat_gradient: Gradient

func _ready() -> void:
  $DepthProgressBar.max_value = Constants.MAX_GEN_DEPTH - Constants.SURFACE_HEIGHT - 1 # border width

  # Background style fo
  var fuel_bg_style = get_base_stylebox()
  fuel_bg_style.bg_color = Color(0.1, 0.1, 0.1)
  $FuelProgressBar.add_theme_stylebox_override("background", fuel_bg_style)

  # Fill (foreground) style for fuel
  var fuel_fill_style = get_base_stylebox()
  fuel_fill_style.bg_color = Color(1.0, 0.65, 0.0)
  $FuelProgressBar.add_theme_stylebox_override("fill", fuel_fill_style)

  # Background style for heat
  var heat_bg_style = get_base_stylebox()
  heat_bg_style.bg_color = Color(0.1, 0.1, 0.1)
  $HeatProgressBar.add_theme_stylebox_override("background", heat_bg_style)

  # Fill (foreground) style for heat
  heat_fill_style.bg_color = Color(0.3, 0.6, 1.0)
  $HeatProgressBar.add_theme_stylebox_override("fill", heat_fill_style)

  heat_gradient = Gradient.new()
  heat_gradient.offsets = HEAT_GRADIENT_DATA.keys()
  heat_gradient.colors = HEAT_GRADIENT_DATA.values()

func _process(delta):
  $Status.text = FUEL_WEIGHT_MONEY_TEMPLATE % [
    GameState.player.current_fuel / 1000,
    GameState.player.get_total_heat(),
    GameState.player.get_total_weight(),
    GameState.player.bank_value
  ]
  $CurrentHaulValue.text = CURRENT_HAUL_VALUE_TEMPLATE % GameState.player.haul_value

  if GameState.player.current_fuel <= 0.0 && !GameState.is_player_above_ground():
    $RespawnHint.visible = true
  else:
    $RespawnHint.visible = false

  # Progress Bars
  $DepthProgressBar.value = GameState.get_player_map_coords().y - Constants.SURFACE_HEIGHT + 1

  $FuelProgressBar.max_value = GameState.player.fuel_capacity
  $FuelProgressBar.value = GameState.player.current_fuel

  $HeatProgressBar.max_value = GameState.player.heat_capacity
  $HeatProgressBar.value = GameState.player.get_total_heat()
  var heat_weight = GameState.player.get_total_heat() / GameState.player.heat_capacity
  heat_fill_style.bg_color = heat_gradient.sample(heat_weight)

  if GameState.has_won():
    $WinNotice.visible = true
  else:
    $WinNotice.visible = false

func get_base_stylebox():
  var style = StyleBoxFlat.new()
  style.corner_radius_top_left = 8
  style.corner_radius_top_right = 8
  style.corner_radius_bottom_left = 8
  style.corner_radius_bottom_right = 8
  return style
