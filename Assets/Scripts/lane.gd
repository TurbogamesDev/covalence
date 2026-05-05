extends Node2D
class_name Lane
    
@export var notes_folder: Node2D
const note_scene = preload("res://Assets/Scenes/note.tscn")

var current_notes: Array[Note] = []

const END_PIXEL_OFFSET = 240.0
const PIXELS_PER_SECOND = 600.0

const BUFFER_BEFORE_DELETION_SECONDS = 0.140

var current_time_seconds: float = 0

func new_position_offset_for_note(target_time_seconds: float):
    return -(PIXELS_PER_SECOND * (target_time_seconds - current_time_seconds))

func spawn_note(target_time_seconds):
    var note: Note = note_scene.instantiate()

    note.position = Vector2(0, END_PIXEL_OFFSET + new_position_offset_for_note(target_time_seconds))

    notes_folder.add_child(note)

    current_notes.append(note)

    note.target_time_seconds = target_time_seconds

func _ready() -> void:
    spawn_note(1.0)
    spawn_note(2.0)
    spawn_note(3.0)
    spawn_note(4.0)
    spawn_note(5.0)

func _process(delta: float) -> void:
    current_time_seconds += delta

    for note: Note in current_notes:
        if not note:
            continue

        note.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(note.target_time_seconds)

        if (note.target_time_seconds + BUFFER_BEFORE_DELETION_SECONDS) < current_time_seconds:
            note.queue_free()

            continue
    



    