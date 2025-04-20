extends RigidBody2D

var haul_value = 0.0
var haul_weight = 0.0
var haul_has_gonster = false

func _ready() -> void:
  if haul_has_gonster:
    $Sprite.texture = preload("res://assets/gonster.png")
  else:
    $Sprite.texture = preload("res://assets/dropped_haul.png")

func _on_player_touched(body: Node) -> void:
  if body is Player && $CollectableTimer.is_stopped():
    body.get_node("PickupSound").play()
    GameState.player.haul_value += haul_value
    GameState.player.haul_weight += haul_weight
    GameState.player.has_gonster = haul_has_gonster || GameState.player.has_gonster
    queue_free()
