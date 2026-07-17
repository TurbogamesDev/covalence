extends Node

var total_start_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}

var total_end_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}


func add_judgement_data_to_result(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool) -> void:
    AccuracyHandler.add_judgement_data_to_accuracy(judgement_data, note_type, end_hit)

    ComboHandler.update_combo_from_judgement_data(judgement_data, note_type, end_hit)

    display_current_result()

func display_current_result():
    print("Current Accuracy: %f" % AccuracyHandler.get_current_accuracy())
    print("Current Strict Accuracy: %f" % AccuracyHandler.get_current_strict_accuracy())
    print("Combo: %d" % ComboHandler.current_combo)

    print("Score: %d" % ScoreHandler.calculate_current_score())