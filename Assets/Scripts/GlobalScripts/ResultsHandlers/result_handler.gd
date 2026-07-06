extends Node

var total_start_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}

var total_end_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}


func add_judgement_data_to_result(judgement_data: JudgementData) -> void:
    AccuracyHandler.add_judgement_data_to_accuracy(judgement_data)

    ComboHandler.update_combo_from_judgement_data(judgement_data)

    display_current_result()

func display_current_result():
    print(AccuracyHandler.get_current_accuracy())

    print("Combo: %d" % ComboHandler.current_combo)