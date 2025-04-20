extends Control

# The year is 3035...
# All resources on planet Earth are exhausted. Society has been a dystopia for generations.
# But a new hope has revealed itself; deep in the bowels of an alien world lies an ancient concoction capable of producing unimaginable efficiency.
# Our brave miner must journey to the depths of...
# DIGMA BALIS
# On Digma Balis, collect resources and sell them at the shop for money that you can use to upgrade your equipment
# But be careful, anything you pick up while you're down there needs to be brought back to the surface if you want to get paid
# Find the ancient concoction at the bottom and bring it to the surface to win

@onready var story1 = $VBoxContainer/Story1
@onready var story2 = $VBoxContainer/Story2
@onready var story3 = $VBoxContainer/Story3
@onready var story4 = $VBoxContainer/Story4
@onready var logo = $VBoxContainer/Logo
@onready var instructions1 = $VBoxContainer/Instructions1
@onready var instructions2 = $VBoxContainer/Instructions2
@onready var instructions3 = $VBoxContainer/Instructions3
@onready var start_game = $VBoxContainer/StartGame

func _ready():
  var script := [
    { "element": story1, "hold_time": 2.0 },
    { "element": story2, "hold_time": 2.0 },
    { "element": story3, "hold_time": 3.0 },
    { "element": story4, "hold_time": 3.0 },
    { "element": logo, "hold_time": 2.0 },
    { "element": instructions1, "hold_time": -0.5 },
    { "element": instructions2, "hold_time": -0.5 },
    { "element": instructions3, "hold_time": -0.5 },
    { "element": start_game, "hold_time": 0.0 },
  ]

  # how long the next element in the script should wait to be shown
  # equal to total hold time of elements before it + 0.5s per element to fade in
  # starts at 0.5 for a dramatic start
  var wait_time = 0.5

  for item in script:
    # hide the item for now
    item["element"].modulate.a = 0.0
    var tween = get_tree().create_tween()
    tween.tween_interval(wait_time)
    tween.tween_property(item["element"], "modulate:a", 1, 0.5)
    wait_time += 0.5 + item["hold_time"]


func _on_start_game_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/main/main.tscn")
