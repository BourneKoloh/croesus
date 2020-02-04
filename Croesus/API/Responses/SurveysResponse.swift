//
//  SurveysResponse.swift
//  Croesus
//
//  Created by Bourne K on 05/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class SurveysResponse: Decodable {
    var title = ""
    var status = ""
    var date = ""
    var desc = ""
    var questions:[QuestionResponse]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case status
        case date = "dateCreated"
        case desc
        case questions
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        status = try container.decode(String.self, forKey: .status)
        date = try container.decode(String.self, forKey: .date)
        questions = try container.decode([QuestionResponse].self, forKey: .questions)
    }
}

class QuestionResponse: Decodable {
    var title = ""
    var kind = ""
    var options:[QuestionOptResponse]?
    var answers:[QuestionAnsResponse]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case kind = "QuestionType"
        case options = "Options"
        case answers
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        kind = try container.decode(String.self, forKey: .kind)
        options = try container.decode([QuestionOptResponse].self, forKey: .options)
        answers = try container.decode([QuestionAnsResponse].self, forKey: .answers)
    }
}

class QuestionOptResponse: Decodable {
    var title = ""
    var value = ""
    
    private enum CodingKeys: String, CodingKey {
        case title
        case value
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        value = try container.decode(String.self, forKey: .value)
    }
}

class QuestionAnsResponse: Decodable {
    var title = ""
    var value = ""
    
    private enum CodingKeys: String, CodingKey {
        case title
        case value
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        value = try container.decode(String.self, forKey: .value)
    }
}
