extends Node

signal lane_pressed(lane_id: int, precise_time: float)
signal lane_released(lane_id: int, precise_time: float)

func _ready() -> void:
    Input.use_accumulated_input = false

func _input(event):
    var precise_time = Time.get_ticks_usec() / 1_000_000.0

    for lane_id in range(4):
        if event.is_action_pressed("lane_%d_keybind" % lane_id):
            lane_pressed.emit(lane_id, precise_time)

        elif event.is_action_released("lane_%d_keybind" % lane_id):
            lane_released.emit(lane_id, precise_time)