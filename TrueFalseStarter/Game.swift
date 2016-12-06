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
    
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var incorrectSound: SystemSoundID = 0
    var outOfTimeSound: SystemSoundID = 0
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var currentQuestion: Question?
    var indexesOfAskedQuestions: [Int] = []
    let lightningRoundTimeInSeconds = 15
    var isCorrentQuestionAnswered = false
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
    
    func getNextQuestion() -> Question {
        
        repeat {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        } while indexesOfAskedQuestions.contains(indexOfSelectedQuestion)
        
        isCorrentQuestionAnswered = false
        
        indexesOfAskedQuestions += [indexOfSelectedQuestion]
        
        let question = questions[indexOfSelectedQuestion]
        
        currentQuestion = question
        
        return question
        
    }
    
    func isAnswered() -> Bool{
        
        return isCorrentQuestionAnswered
        
    }
    
    func checkAnswerOfCurrentQuestion() -> Int {
        
        questionsAsked += 1
        isCorrentQuestionAnswered = true
        
        return (currentQuestion?.indexOfCorrectAnswer)!
        
    }
    
    func checkAnswerOfCurrentQuestion(withAnswerIndex: Int) -> (isCorrect: Bool, index: Int) {
        
        // Increment the questions asked counter
        questionsAsked += 1
        isCorrentQuestionAnswered = true
        
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
        
        isCorrentQuestionAnswered = false
        questionsAsked = 0
        correctQuestions = 0
        indexesOfAskedQuestions = []
        
    }
    
    // Audio Methods
    
    func loadGameSounds() {
        
        let pathToGameSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToGameSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "CorrectSound", ofType: "mp3")
        let correctSoundURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL as CFURL, &correctSound)
        
        let pathToIncorrectSoundFile = Bundle.main.path(forResource: "IncorrectSound", ofType: "wav")
        let incorrectSoundURL = URL(fileURLWithPath: pathToIncorrectSoundFile!)
        AudioServicesCreateSystemSoundID(incorrectSoundURL as CFURL, &incorrectSound)
        
        let pathToOOTSoundFile = Bundle.main.path(forResource: "OotSound", ofType: "mp3")
        let outOfTimeSoundURL = URL(fileURLWithPath: pathToOOTSoundFile!)
        AudioServicesCreateSystemSoundID(outOfTimeSoundURL as CFURL, &outOfTimeSound)
        
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    
    func playOutOfTimeSound() {
        AudioServicesPlaySystemSound(outOfTimeSound)
    }
    
}
