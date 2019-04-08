//
//  PlayViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import Lottie
import PMAlertController

class PlayViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    @IBOutlet weak var quizBox: UIView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var firstFactorLb: UILabel!
    @IBOutlet weak var secondFactorLb: UILabel!
    @IBOutlet weak var resultLb: UILabel!
    @IBOutlet weak var speakingRow: UIView!
    @IBOutlet weak var questionNumberLb: UILabel!
    @IBOutlet weak var scoreLb: UILabel!
    @IBOutlet weak var wrongNumberLb: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    // MARK: - class variables
    var firFactor = 0
    var secFactor = 0
    var result = 0
    
    var currentQuestionNumber = 0
    var score = 0
    var wrong = 0
    
    var originPositionOfButtons: [CGPoint] = []
    
    
    // MARK: - LOTTIE ANIMATION
    let wrongAnswer = LOTAnimationView(name: "wrong")
    let rightAnswer = LOTAnimationView(name: "correct")

    
    // MARK: - START...
    
    override func viewDidLayoutSubviews() {
        self.leftContainer.layer.cornerRadius = 15
        self.rightContainer.layer.cornerRadius = 15
        
        for button in answerButtons {
            button.layer.cornerRadius = 15
            button.addShadowTitle()
        }
        
        speakingRow.layer.borderWidth = 1.5
        speakingRow.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        speakingRow.layer.cornerRadius = 20
        speakingRow.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForPanGesture()
        self.prepareGameSession()
        self.createAnimationView()
    }
    
    
    // MARK: - custom functions
    
    func createAnimationView() {
        
        // circle
        self.wrongAnswer.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        wrongAnswer.contentMode = .scaleAspectFit
        self.circleView.addSubview(wrongAnswer)
        self.wrongAnswer.center = CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2)
        self.wrongAnswer.animationSpeed = 1.0
        
        // correct
        self.rightAnswer.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        rightAnswer.contentMode = .scaleAspectFit
        self.circleView.addSubview(rightAnswer)
        self.rightAnswer.center = CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2)
        
        self.circleView.isHidden = true
    }
    
    private func getButtonComeBackHome() {
        for button in answerButtons {
            UIView.animate(withDuration: 0.3) {
                if let offset = self.answerButtons.index(where: { $0.tag == button.tag }) {
                    button.frame.origin = self.originPositionOfButtons[offset]
                }
            } // end uiview
        } // end for
    }
    
    private func prepareGameSession() {
        self.score = 0
        self.wrong = 0
        self.scoreLb.text = "0"
        self.wrongNumberLb.text = "0"
        self.currentQuestionNumber = 0
        
        self.generateFactors()
        self.generateAnswers()
        
        self.getButtonComeBackHome()
    }
    
    private func generateFactors() {
        firFactor = Int.random(in: 1...20)
        secFactor = Int.random(in: 1...10)
        
        result = firFactor * secFactor
        
        firstFactorLb.text = "\(firFactor)"
        secondFactorLb.text = "\(secFactor)"
        
        resultLb.text = "??"
        
        self.currentQuestionNumber += 1
        self.questionNumberLb.text = "\(self.currentQuestionNumber)"
    }
    
    
    
    private func generateAnswers() {
        // 1. random 2 wrong-answers
        var answers = [Int]()
        answers.append(result)
        
        if result == 200 {
            answers.append(Int.random(in: 1...100))
            answers.append(Int.random(in: 101...200))
        } else {
            answers.append(Int.random(in: 1...result-1))
            answers.append(Int.random(in: result+1...200))
        }
        
        answers.append(Int.random(in: 201...250))
        
        
        answers.shuffle()
        // 2. add answer to button
        for button in answerButtons {
            button.alpha = 1
            button.setTitle("\(answers[answerButtons.index(of: button)!])", for: [])
            button.tag = answers[answerButtons.index(of: button)!]
        } // end for
    }
    
    private func prepareForTheNextQuestion() {
        
        if self.currentQuestionNumber >= 10 {
            self.showAlert(score: self.score)
            self.saveScoreData(score: self.score)
        } else {
            self.leftContainer.backgroundColor = #colorLiteral(red: 0.1211252883, green: 0.6885247827, blue: 0.8350743651, alpha: 1)
            self.rightContainer.backgroundColor = #colorLiteral(red: 0.1211252883, green: 0.6885247827, blue: 0.8350743651, alpha: 1)
            
            self.generateFactors()
            self.generateAnswers()
            
            self.getButtonComeBackHome()
        } // end if
        
    }
    
    private func saveScoreData(score: Int) {
        let scoreSheet = UserDefaults.standard
        switch score {
        case 10:
            if var goldCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.goldCount) as? Int {
                goldCount += 1
                scoreSheet.set(goldCount, forKey: Constant.KeyUserDefaults.goldCount)
            }
            break
            
        case 9, 8:
            if var silverCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.silverCount) as? Int {
                silverCount += 1
                scoreSheet.set(silverCount, forKey: Constant.KeyUserDefaults.silverCount)
            }
            break
        case 7:
            if var bronzeCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.bronzeCount) as? Int {
                bronzeCount += 1
                scoreSheet.set(bronzeCount, forKey: Constant.KeyUserDefaults.bronzeCount)
            }
            break
        default:
            break
        }
        
        var array = scoreSheet.value(forKey: Constant.KeyUserDefaults.highScore) as? [String : Int]
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let playedDate = formatter.string(from: date)
        
        array![playedDate] = score
        let sortedByValueDictionary = array!.sorted { $0.1 < $1.1 }
        
        array?.removeAll()
        for (key, value) in sortedByValueDictionary {
            array![key] = value
        }
        
        scoreSheet.set(array, forKey: Constant.KeyUserDefaults.highScore)
    }
    
    private func updateLabel(scoreOffset: Int, wrongOffset: Int) {
        self.score += scoreOffset
        self.wrong += wrongOffset
        self.scoreLb.text = "\(score)"
        self.wrongNumberLb.text = "\(wrong)"
    }
    
    private func showAlert(score: Int) {
        
        var title = ""
        var image = UIImage(named: "sad")
        
        if score < 5 {
            title = "You're unlucky!"
        } else {
            title = "Congratulations!"
            image = UIImage(named: "happy")
        }
        
        let alertVC = PMAlertController(title: title, description: "You want to continue playing?", image: image!, style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Stop", style: .cancel, action: { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.mainViewController) as! MainViewController
            self.present(vc, animated: true)
        }))
        
        alertVC.addAction(PMAlertAction(title: "Continue", style: .default, action: { () in
            self.prepareGameSession()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func prepareForPanGesture() {
        for button in answerButtons {
            // save the original position of every button
            originPositionOfButtons.append(button.frame.origin)
            self.addPanGesture(to: button)
            button.layer.zPosition = 1.0
        } // end for
    }
    
    func addPanGesture(to button: UIButton) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        button.addGestureRecognizer(pan)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.mainViewController) as! MainViewController
        self.present(vc, animated: true)
    }
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        
        let numberView = sender.view!
        let translation = sender.translation(in: self.view)
        
        switch sender.state {
        case .began, .changed: // >>>> start moving finger

            // moving the pan
            numberView.center = CGPoint(x: numberView.center.x + translation.x, y: numberView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            
            let panPoint = sender.location(in: self.quizBox)
            
            if self.quizBox.frame.contains(panPoint) {
                self.speakingRow.isHidden = false
            } else {
                self.speakingRow.isHidden = true
            }
            
        case .ended: // >>> lift up the finger
            
            
            self.speakingRow.isHidden = true
            
            let panPoint = sender.location(in: self.quizBox)
            
            self.circleView.isHidden = false
            
            if self.quizBox.frame.contains(panPoint) {
                let answer = (numberView as! UIButton).tag
                // the answer is right
                if self.result == answer {
                    self.updateLabel(scoreOffset: 1, wrongOffset: 0)
                    resultLb.text = "\(answer)"
                    MusicHelper.shared.play(name: "correct")
                    self.rightContainer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    self.leftContainer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    UIView.animate(withDuration: 0.3) {
                        numberView.alpha = 0.0
                    }
                    self.rightAnswer.play { (ok) in
                        if ok {
                            self.rightAnswer.stop()
                            self.circleView.isHidden = true
                            self.prepareForTheNextQuestion()
                        }
                    }
                    
                // the answer is wrong
                } else {
                    self.updateLabel(scoreOffset: -1, wrongOffset: 1)
                    MusicHelper.shared.play(name: "wrong")
                    // come back to the original position
                    self.wrongAnswer.play { (ok) in
                        if ok {
                            self.wrongAnswer.stop()
                            self.circleView.isHidden = true
                        } // endif
                    }
                    
                    UIView.animate(withDuration: 0.3) {
                        if let offset = self.answerButtons.index(where: { $0.tag == numberView.tag }) {
                            numberView.frame.origin = self.originPositionOfButtons[offset]
                        }
                    } // end uiview
                } // end if
            
            } else {
                
                self.circleView.isHidden = true
                UIView.animate(withDuration: 0.3) {
                    if let offset = self.answerButtons.index(where: { $0.tag == numberView.tag }) {
                        numberView.frame.origin = self.originPositionOfButtons[offset]
                    }
                } // end uiview
            }
            
            
        default:
            break
        } // end switch
        
    } // end method
}
