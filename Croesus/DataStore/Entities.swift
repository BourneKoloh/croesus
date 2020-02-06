//
//  AppServices.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

struct SurveyEntity{
    //
    static let TABLE_NAME = "Survey"
    //
    static let COLUMN_ID = "id"
    static let COLUMN_TITLE = "title"
    static let COLUMN_DESC = "desc"
    static let COLUMN_DATE_ADDED = "date_added"
    static let COLUMN_KIND = "status"
}

struct QuestionEntity{
    //
    static let TABLE_NAME = "question"
    //
    static let COLUMN_ID = "id"
    static let COLUMN_TITLE = "title"
    static let COLUMN_DATE_ADDED = "date_added"
    static let COLUMN_TYPE = "kind"
    //
    static let COLUMN_SURVEY = "survey_id"
}

struct ChoiceEntity{
    //
    static let TABLE_NAME = "choice"
    //
    static let COLUMN_ID = "id"
    static let COLUMN_TITLE = "title"
    static let COLUMN_DATE_ADDED = "date_added"
    static let COLUMN_VALUE = "value"
    //
    static let COLUMN_QUESTION = "question_id"
}

struct AnswerEntity{
    //
    static let TABLE_NAME = "choice"
    //
    static let COLUMN_ID = "id"
    static let COLUMN_DATE_ADDED = "date_added"
    static let COLUMN_VALUE = "value"
    //
    static let COLUMN_QUESTION = "answer_id"
}
