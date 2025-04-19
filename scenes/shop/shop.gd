extends Node2D

# true if the player is at the shop
var player_present = false
# true if the player is shopping (i.e. they pressed interact while at the shop)
var is_shopping = false

func _process(delta):
  if Input.is_action_just_pressed("interact") && player_present:
    is_shopping = true
    %Player.refuel()

func _on_player_entered(body: Node2D) -> void:
  player_present = true
  $F.visible = true

func _on_player_exited(body: Node2D) -> void:
  player_present = false
  $F.visible = false
