import UIKit

struct TriviaQuestion: Decodable {
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
struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}
class TriviaViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ButtonAnswer1: UIButton!
    @IBOutlet weak var ButtonAnswer2: UIButton!
    @IBOutlet weak var ButtonAnswer3: UIButton!
    @IBOutlet weak var ButtonAnswer4: UIButton!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var relatedImage: UIImageView!
    let correctAnswerIndex: Int = 0
    var userAnswerIndex: Int?
    var currentQuestionIndex = 0
    var userScore = 0
    var triviaQuestions = [TriviaQuestion]()
    var answers:[String] = []
//    var triviaQuestions: [TriviaQuestion] = [
//        TriviaQuestion(
//            category: "Music",
//            question: "Who is often referred to as the 'King of Pop'?",
//            answers: ["a) Elvis Presley", "b) Michael Jackson", "c) Madonna", "d) The Beatles"],
//            correctAnswerIndex: 1,
//            userAnswerIndex: nil
//        ),
//        TriviaQuestion(
//            category:"History",
//            question: "Which ancient civilization is known for building the Great Wall of China?",
//            answers: ["a) Roman Empire", "b) Egyptian Empire", "c) Inca Empire", "d) Chinese Empire (Qin Dynasty)"],
//            correctAnswerIndex: 3,
//            userAnswerIndex: nil
//        ),
//        TriviaQuestion(
//            category: "Sports",
//            question: "Which sport is played in the Super Bowl championship game in the United States?",
//            answers: ["a) Baseball", "b) Basketball", "c) American Football", "d) Soccer"],
//            correctAnswerIndex: 2,
//            userAnswerIndex: nil
//        )
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTriviaQuestions()
        if currentQuestionIndex < triviaQuestions.count {
            self.answers = displayQuestion()
        } else {
            // End of the game
            showFinalScore() // Display the final score pop-up
        }
    }
    func fetchTriviaQuestions() {
        let triviaService = TriviaQuestionService()
        
        triviaService.fetchTriviaQuestions { [weak self] (questions, error) in
            
            guard let strongSelf = self else { return }
            
            // Handle errors
            if let error = error {
                print("Error fetching questions: \(error.localizedDescription)")
                return
            }
            
            guard let questions = questions else {
                print("No questions returned")
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.triviaQuestions = questions
                self?.answers = strongSelf.displayQuestion()
            }
        }
    }
   
    
    func showFinalScore() {
        // Calculate the user's final score here
        let finalScore = calculateFinalScore()
        
        // Create a UIAlertController to display the final score
        let alertController = UIAlertController(title: "Game Over", message: "Your Score: \(userScore)", preferredStyle: .alert)
        
        // Add an action to dismiss the alert
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // Handle the OK button press (e.g., reset the game)
        }
        alertController.addAction(dismissAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func calculateFinalScore() -> Int {
        var userScore = 0 // Initialize userScore to zero
            
        for _ in triviaQuestions {
                let correctAnswerIndex = correctAnswerIndex
                if let userAnswerIndex = userAnswerIndex, userAnswerIndex == correctAnswerIndex {
                    // If the user answered this question and their answer is correct, increment the score
                    userScore += 1
                }
            }
            
            return userScore
    }
    
    func displayQuestion() -> Array<String>{
        let currentQuestion = triviaQuestions[currentQuestionIndex]
        questionLabel.text = currentQuestion.question
        category.text = currentQuestion.category
               
        // Update the question number label
        let questionNumberText = "Question \(currentQuestionIndex + 1)/\(triviaQuestions.count)"
        questionNumber.text = questionNumberText
        relatedImage.image = UIImage(named: currentQuestion.category)
        var answers:[String] = []
        answers.append(currentQuestion.correctAnswer)
        for incorrectAnswer in currentQuestion.incorrectAnswers {
          
            answers.append(incorrectAnswer)
            
        }
        // Shuffle the answers
        answers.shuffle()
        print("herreeee", answers)
    
        let isBooleanQuestion = answers.count == 2

        if isBooleanQuestion {  // If it's a true or false question
            ButtonAnswer1.setTitle(answers[0], for: .normal)
            ButtonAnswer2.setTitle(answers[1], for: .normal)
            
            ButtonAnswer1.isHidden = false
            ButtonAnswer2.isHidden = false
            ButtonAnswer3.isHidden = true
            ButtonAnswer4.isHidden = true
        } else {  // If it's a multiple choice question
            if answers.count > 0 {
                ButtonAnswer1.setTitle(answers[0], for: .normal)
                ButtonAnswer1.isHidden = false
            }
            if answers.count > 1 {
                ButtonAnswer2.setTitle(answers[1], for: .normal)
                ButtonAnswer2.isHidden = false
            }
            if answers.count > 2 {
                ButtonAnswer3.setTitle(answers[2], for: .normal)
                ButtonAnswer3.isHidden = false
            }
            if answers.count > 3 {
                ButtonAnswer4.setTitle(answers[3], for: .normal)
                ButtonAnswer4.isHidden = false
            }
        }
        return answers
    }
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        // Reset game state variables
        currentQuestionIndex = 0
        userScore = 0
        
        // Display the first question
        self.answers = displayQuestion()
       
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let currentQuestion = triviaQuestions[currentQuestionIndex]
        let correctAnswerIndex = answers.firstIndex(of: triviaQuestions[currentQuestionIndex].correctAnswer)
        let selectedAnswerIndex = [ButtonAnswer1, ButtonAnswer2, ButtonAnswer3, ButtonAnswer4].firstIndex(of: sender)
        
        // Debug print statements
        print("Selected Answer Index: \(selectedAnswerIndex)")
        print("Correct Answer Index: \(correctAnswerIndex)")
        
        // Update the userAnswerIndex property for the current question
//        userAnswerIndex = selectedAnswerIndex
        
        if selectedAnswerIndex == correctAnswerIndex {
            // Handle correct answer
            userScore += 1 // Increment the user's score for a correct answer
            print(userScore, "hereee its increasedddddddddddddddddddddddddddddd")
        } else {
            // Handle incorrect answer
        }
        
        currentQuestionIndex += 1
        if currentQuestionIndex < triviaQuestions.count {
            self.answers = displayQuestion()
        } else {
            // End of the game
            showFinalScore() // Display the final score pop-up
        }
    }
}
