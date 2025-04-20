extends Node2D

var player_present = false

func _process(delta):
  if Input.is_action_just_pressed("interact") && player_present:
    if GameState.player.refuel():
      $RefuelSound.play()
    $FGlyph.visible = false

func _on_player_entered(body: Node2D) -> void:
  player_present = true
  if GameState.player.current_fuel < GameState.player.fuel_capacity:
    $FGlyph.visible = true
    $FGlyph.play()

func _on_player_exited(body: Node2D) -> void:
  player_present = false
  $FGlyph.visible = false
