extends Node2D
class_name LaneHandler

@export var lanes: Array[Lane]

# var current_time_seconds: float = 0

var current_parsed_chart: ParsedChart

func spawn_note_in_lane(lane_no: int, target_time: float) -> void:
    var lane: Lane = lanes[lane_no]

    lane.spawn_note(target_time)

func _ready() -> void:
    current_parsed_chart = ParsedChart.init_from_file("res://Assets/Charts/test_chart_1.json")

    # print(parsed_chart.chart_data)

    spawn_note_in_lane(0, 1.00)
    spawn_note_in_lane(1, 1.25)
    spawn_note_in_lane(2, 1.50)
    spawn_note_in_lane(3, 1.75)

    spawn_note_in_lane(0, 2.00)
    spawn_note_in_lane(1, 2.25)
    spawn_note_in_lane(2, 2.50)
    spawn_note_in_lane(3, 2.75)

    spawn_note_in_lane(0, 3.00)
    spawn_note_in_lane(1, 3.25)
    spawn_note_in_lane(2, 3.50)
    spawn_note_in_lane(3, 3.75)

    spawn_note_in_lane(0, 4.00)
    spawn_note_in_lane(1, 4.25)
    spawn_note_in_lane(2, 4.50)
    spawn_note_in_lane(3, 4.75)

    spawn_note_in_lane(0, 5.00)
    spawn_note_in_lane(1, 5.25)
    spawn_note_in_lane(2, 5.50)
    spawn_note_in_lane(3, 5.75)

    
    

    # spawn_note(1.0 + 0.25*lane_id)
    # spawn_note(2.0 + 0.25*lane_id)
    # spawn_note(3.0 + 0.25*lane_id)
    # spawn_note(4.0 + 0.25*lane_id)
    # spawn_note(5.0 + 0.25*lane_id)

func _process(delta: float) -> void:
    if not current_parsed_chart:
        return

    for lane: Lane in lanes:
        var notes_in_lane_for_delta_time_period = current_parsed_chart.get_notes_for_lane_in_timeframe(lane.lane_id, ChartTimeSynchroniser.current_time, ChartTimeSynchroniser.current_time + delta)

        if len(notes_in_lane_for_delta_time_period) > 0:
            print(notes_in_lane_for_delta_time_period)


    



    