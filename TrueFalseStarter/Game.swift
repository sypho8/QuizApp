//
//  Trivia.swift
//  TrueFalseStarter
//
//  Created by Dan on 12/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameKit
import AudioToolbox

class Game {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var gameSound: SystemSoundID = 0
    var currentQuestion: Question?
    var indexesOfAskedQuestions: [Int] = []
    let lightningRoundTimeInSeconds = 15
    let inLightningMode = true
    let questions: [Question] = [
                                    Question(question: "This was the only US President to serve more than two consecutive terms.", possibleAnswers: ["George Washington","Franklin D. Roosevelt","Woodrow Wilson","Andrew Jackson"], indexOfCorrectAnswer: 1),
                                    Question(question: "Which of the following countries has the most residents?", possibleAnswers: ["Nigeria","Russia","Iran","Vietnam"], indexOfCorrectAnswer: 0),
                                    Question(question: "In what year was the United Nations founded?", possibleAnswers: ["1918","1919","1945","1954"], indexOfCorrectAnswer: 2),
                                    Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", possibleAnswers: ["Paris","Washington D.C.","New York City","Boston"], indexOfCorrectAnswer: 2),
                                    Question(question: "Which nation produces the most oil?", possibleAnswers: ["Iran","Iraq","Brazil","Canada"], indexOfCorrectAnswer: 3),
                                    Question(question: "Which country has most recently won consecutive World Cups in Soccer?", possibleAnswers: ["Italy","Brazil","Argetina","Spain"], indexOfCorrectAnswer: 1),
                                    Question(question: "Which of the following rivers is longest?", possibleAnswers: ["Yangtze","Mississippi","Congo","Mekong"], indexOfCorrectAnswer: 1),
                                    Question(question: "Which city is the oldest?", possibleAnswers: ["Mexico City","Cape Town","San Juan","Sydney"], indexOfCorrectAnswer: 0),
                                    Question(question: "Which country was the first to allow women to vote in national elections?", possibleAnswers: ["Poland","United States","Sweden","Senegal"], indexOfCorrectAnswer: 0),
                                    Question(question: "Which of these countries won the most medals in the 2012 Summer Games?", possibleAnswers: ["France","Germany","Japan","Great Britian"], indexOfCorrectAnswer: 3)
                                ]
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func getNextQuestion() -> Question {
        
        repeat {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        } while indexesOfAskedQuestions.contains(indexOfSelectedQuestion)
        
        indexesOfAskedQuestions += [indexOfSelectedQuestion]
        
        let question = questions[indexOfSelectedQuestion]
        
        currentQuestion = question
        
        return question
    }
    
    func checkAnswerOfCurrentQuestion() -> Int {
        questionsAsked += 1
        return (currentQuestion?.indexOfCorrectAnswer)!
    }
    
    func checkAnswerOfCurrentQuestion(withAnswerIndex: Int) -> (isCorrect: Bool, index: Int) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let correctAnswerIndex = (currentQuestion?.indexOfCorrectAnswer)!
        
        // Return wether the answer is true or false
        if withAnswerIndex ==  correctAnswerIndex{
            correctQuestions += 1
            return (true, correctAnswerIndex)
        }
        return (false, correctAnswerIndex)
    }
    
    func getLightningTime() -> Int {
        return lightningRoundTimeInSeconds
    }
    
    func getScore() -> (correctQuestions: Int,questionsPerRound: Int) {
        return (correctQuestions, questionsPerRound)
    }
    
    func getCurrentQuestionIndex() -> Int {
        return (currentQuestion?.indexOfCorrectAnswer)!
    }
    
    func isOver() -> Bool {
        if questionsAsked == questionsPerRound {
            return true
        }
        return false
    }
    
    func isLastRound() -> Bool {
        if questionsAsked + 1 == questionsPerRound {
            return true
        }
        return false
    }
    
    func isLightning() -> Bool {
        return inLightningMode
    }
    
    func playAgain() {
        questionsAsked = 0
        correctQuestions = 0
        indexesOfAskedQuestions = []
    }
    
}
