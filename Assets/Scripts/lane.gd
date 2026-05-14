extends Node2D
class_name Lane
    
@export var notes_folder: Node2D
@export var lane_id: int
const note_scene = preload("res://Assets/Scenes/note.tscn")

var current_notes: Array[Note] = []

const END_PIXEL_OFFSET = 240.0
const PIXELS_PER_SECOND = 600.0

const BUFFER_BEFORE_DELETION_SECONDS = 0.140

var current_time_seconds: float = 0

var current_parsed_chart: ParsedChart

func new_position_offset_for_note(target_time_seconds: float):
    return -(PIXELS_PER_SECOND * (target_time_seconds - current_time_seconds))

func spawn_note(target_time_seconds):
    var note: Note = note_scene.instantiate()

    note.position = Vector2(0, END_PIXEL_OFFSET + new_position_offset_for_note(target_time_seconds))

    notes_folder.add_child(note)

    current_notes.append(note)

    note.target_time_seconds = target_time_seconds

func _ready() -> void:
    current_parsed_chart = ParsedChart.init_from_file("res://Assets/Charts/test_chart_1.json")

    # print(parsed_chart.chart_data)

    spawn_note(1.0 + 0.25*lane_id)
    spawn_note(2.0 + 0.25*lane_id)
    spawn_note(3.0 + 0.25*lane_id)
    spawn_note(4.0 + 0.25*lane_id)
    spawn_note(5.0 + 0.25*lane_id)

func _process(delta: float) -> void:
    if current_parsed_chart:
        var notes_in_lane_for_delta_time_period = current_parsed_chart.get_notes_for_lane_in_timeframe(lane_id, current_time_seconds, current_time_seconds + delta)

        if len(notes_in_lane_for_delta_time_period) > 0:
            print(notes_in_lane_for_delta_time_period)

    current_time_seconds += delta

    for note: Note in current_notes:
        if not note:
            continue

        note.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(note.target_time_seconds)

        if (note.target_time_seconds + BUFFER_BEFORE_DELETION_SECONDS) < current_time_seconds:
            note.queue_free()

            continue
    



    