extends Area2D

func _on_player_touched(body: Node) -> void:
  if body is Player:
    print("Gonster Picked Up")
    body.get_node("PickupSound").play()
    GameState.player.has_gonster = true
    queue_free()
