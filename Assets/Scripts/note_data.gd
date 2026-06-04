extends RefCounted
class_name NoteData

var start_time: float
var end_time: float

var note_type: Enums.NOTE_TYPE
var instant: bool

var note_instance: Note

var note_already_hit: bool = false
var note_held_down: bool = false