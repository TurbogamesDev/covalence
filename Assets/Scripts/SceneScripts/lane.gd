extends Node2D
class_name Lane
	
@export var notes_folder: Node2D
@export var lane_id: int
@export var hit_effect_polygon_2d: LaneHitEffect

const NOTE_TYPE_TO_RESOURCE: Dictionary[Enums.NOTE_TYPE, Resource] = {
	Enums.NOTE_TYPE.REGULAR_NOTE: preload("res://Assets/Scenes/note.tscn"),
	Enums.NOTE_TYPE.HOLD_NOTE: preload("res://Assets/Scenes/hold_note.tscn")
}

var current_note_datas: Array[NoteData] = []

const END_PIXEL_OFFSET = 240.0
const PIXELS_PER_SECOND = 1500.0

const BUFFER_BEFORE_DELETION_SECONDS = 0.141

const VISUAL_OFFSET = -0.018

# var current_time_seconds: float = 0

static func new_position_offset_for_note(target_time_seconds: float):
	return -(PIXELS_PER_SECOND * (target_time_seconds + VISUAL_OFFSET - ChartTimeSynchroniser.current_rhythm_time()))

func spawn_note(note_data: NoteData):
	print("note spawned! %f" % ChartTimeSynchroniser.current_rhythm_time())

	var note: Note = NOTE_TYPE_TO_RESOURCE[note_data.note_type].instantiate()

	note.position = Vector2(0, END_PIXEL_OFFSET + new_position_offset_for_note(note_data.start_time))

	notes_folder.add_child(note)

	note_data.note_instance = note

	current_note_datas.append(note_data)

	# note.start_time = note_data.start_time
	# note.end_time = note_data.end_time

	if note is HoldNote:
		note.change_tail_length(PIXELS_PER_SECOND * (note_data.end_time - note_data.start_time))

func handle_regular_note_update(note_data: NoteData):
	note_data.note_instance.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(note_data.start_time)

func handle_hold_note_update(hold_note_data: NoteData):
	var hold_note_instance = hold_note_data.note_instance

	if hold_note_data.note_held_down:	
		hold_note_instance.change_tail_length(PIXELS_PER_SECOND * (hold_note_data.end_time - ChartTimeSynchroniser.current_rhythm_time()))

		hold_note_instance.position.y = END_PIXEL_OFFSET

		if (hold_note_data.end_time - ChartTimeSynchroniser.current_rhythm_time()) < 0:
			if hold_note_data.note_already_hit:
				return

			hold_note_data.note_already_hit = true

			hold_note_data.note_hit_judgement_data = JudgementManager.calculate_judgement_data_for_press(hold_note_data.note_type, 0)

			print("-- judgement: %s" % hold_note_data.note_hit_judgement_data.judgement_offset)

			handle_note_completion(hold_note_data)

	else:
		hold_note_instance.position.y = END_PIXEL_OFFSET + new_position_offset_for_note(hold_note_data.start_time) 

func handle_note_completion(note_data: NoteData):
	# if note_data.instant:
	# 	self.hit_effect_polygon_2d.activate_hit_effect()

	# self.hit_effect_polygon_2d.deactivate_hit_effect()

	# if not is_instance_valid(note_data.note_instance):
	# 	return

	# if note_data.note_instance.is_queued_for_deletion():
	# 	return
	
	note_data.note_instance.queue_free()

func _process(_delta: float) -> void:
	for note_data: NoteData in current_note_datas:
		if not note_data.note_instance:
			continue

		if note_data.note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
			handle_regular_note_update(note_data)
		elif note_data.note_type == Enums.NOTE_TYPE.HOLD_NOTE:
			handle_hold_note_update(note_data)

		if (note_data.start_time + BUFFER_BEFORE_DELETION_SECONDS) > ChartTimeSynchroniser.current_rhythm_time():
			continue

		if note_data.note_already_hit:
			return

		var offset = 1000 * (ChartTimeSynchroniser.current_rhythm_time() - note_data.start_time)

		if note_data.note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
			handle_note_completion(note_data)
		elif note_data.note_type == Enums.NOTE_TYPE.HOLD_NOTE:
			if note_data.note_held_down:
				continue

			handle_note_completion(note_data)

		note_data.note_hit_judgement_data =  JudgementManager.calculate_judgement_data_for_press(note_data.note_type, offset)

		print("judgement: %s" % note_data.note_hit_judgement_data.judgement_offset)

			
	



	
