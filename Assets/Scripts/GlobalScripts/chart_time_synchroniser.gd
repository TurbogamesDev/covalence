extends Node

var chart_start_time: float = 0.0

const CHART_TIME_OFFSET: float = -2.0

# func _process(delta) -> void:
#     current_time += delta

func _ready() -> void:
    chart_start_time = Time.get_ticks_usec() / 1_000_000.0

func get_rhythm_time_from_precise_time(precise_time: float) -> float:
    return (precise_time - chart_start_time + CHART_TIME_OFFSET)

func current_rhythm_time() -> float:
    return ((Time.get_ticks_usec() / 1_000_000.0) - chart_start_time) + CHART_TIME_OFFSET