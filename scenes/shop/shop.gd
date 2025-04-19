extends Node2D

func _on_player_entered(body: Node2D) -> void:
  print("yo", body.get_class())
  pass # Replace with function body.
