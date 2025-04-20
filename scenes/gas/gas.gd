extends Node2D

var player_present = false

func _process(delta):
  if Input.is_action_just_pressed("interact") && player_present:
    GameState.player.refuel()

func _on_player_entered(body: Node2D) -> void:
  player_present = true
  $FGlyph.visible = true
  $FGlyph.play()

func _on_player_exited(body: Node2D) -> void:
  player_present = false
  $FGlyph.visible = false
