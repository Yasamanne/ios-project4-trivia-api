//
//  CurrentQuestion.swift
//  Trivia
//
//  Created by Yasaman Emami on 10/13/23.
//

import Foundation
import UIKit
//struct CurrentQuestion{
//    let category: String
//    let type: String
//    let difficulty: String
//    let question: String
//    let correct_answer:String
//    let incorrect_answers: Array<String>
//}
struct CurrentQuestion: Decodable  {
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
            case category
            case question
            case correctAnswer = "correct_answer"
            case incorrectAnswers = "incorrect_answers"
        }
}


