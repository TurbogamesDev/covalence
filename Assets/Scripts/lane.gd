extends Node2D
class_name Lane
    
@export var notes_folder: Node2D
@export var lane_id: int

const NOTE_TYPE_TO_RESOURCE: Dictionary[Enums.NOTE_TYPE, Resource] = {
    Enums.NOTE_TYPE.REGULAR_NOTE: preload("res://Assets/Scenes/note.tscn"),
    Enums.NOTE_TYPE.HOLD_NOTE: preload("res://Assets/Scenes/hold_note.tscn")
}

var current_notes: Array[Note] = []

const END_PIXEL_OFFSET = 240.0
const PIXELS_PER_SECOND = 900.0

const BUFFER_BEFORE_DELETION_SECONDS = 0 # 0.140

# var current_time_seconds: float = 0

static func new_position_offset_for_note(target_time_seconds: float):
    return -(PIXELS_PER_SECOND * (target_time_seconds - ChartTimeSynchroniser.current_time))

func spawn_note(note_data: NoteData):
    var note: Note = NOTE_TYPE_TO_RESOURCE[note_data.note_type].instantiate()

    note.position = Vector2(0, END_PIXEL_OFFSET + new_position_offset_for_note(note_data.start_time))

    notes_folder.add_child(note)

    current_notes.append(note)

    note.start_time = note_data.start_time
    note.end_time = note_data.end_time

    if note is HoldNote:
        note.change_tail_length(PIXELS_PER_SECOND * (note.end_time - note.start_time))

func handle_regular_note_update(note: Note):
    note.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(note.start_time) 

func handle_hold_note_update(hold_note: HoldNote):
    if hold_note.start_time > ChartTimeSynchroniser.current_time:
        hold_note.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(hold_note.start_time) 

        return

    hold_note.change_tail_length(PIXELS_PER_SECOND * (hold_note.end_time - ChartTimeSynchroniser.current_time))

    hold_note.position.y = END_PIXEL_OFFSET

func _process(_delta: float) -> void:
    for note: Note in current_notes:
        if not note:
            continue

        if note is HoldNote:
            handle_hold_note_update(note)
        else:
            handle_regular_note_update(note)

        if (note.end_time + BUFFER_BEFORE_DELETION_SECONDS) < ChartTimeSynchroniser.current_time:
            note.queue_free()

            continue
    



    