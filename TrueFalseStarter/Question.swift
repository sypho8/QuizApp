//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Dan on 12/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

struct Question {
    let question: String
    let possibleAnswers: [String]
    let indexOfCorrectAnswer: Int
    
    // Return whether question has 4 possible answers
    func hasFourthOption() -> Bool {
        if possibleAnswers.count == 4 {
            return true
        }
        return false
    }
}
