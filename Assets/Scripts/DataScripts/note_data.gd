extends RefCounted
class_name NoteData

var start_time: float
var end_time: float

var note_type: Enums.NOTE_TYPE
var instant: bool

var note_instance: Note

var note_already_hit: bool = false
var note_held_down: bool = false

var note_hit_judgement_data: JudgementData
var note_release_judgement_data: JudgementData

func _init(raw_note_data: Dictionary):
    self.start_time = raw_note_data["start_time"]
    self.end_time = raw_note_data["end_time"]

    self.note_type = raw_note_data["note_id"]
    self.instant = raw_note_data["instant"]