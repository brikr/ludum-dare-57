extends RigidBody2D

var haul_value = 0.0
var haul_weight = 0.0

func _on_player_touched(body: Node) -> void:
  if body is Player && $CollectableTimer.is_stopped():
    GameState.player.haul_value += haul_value
    GameState.player.haul_weight += haul_weight
    queue_free()
