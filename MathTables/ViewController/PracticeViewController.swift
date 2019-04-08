//
//  PracticeViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import Lottie

class PracticeViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var multiplicationTableView: UITableView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var labelForDragging: UILabel!
    @IBOutlet weak var speakingRow: UIView!
    @IBOutlet weak var bottomNumberStackView: UIStackView!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var confettiView: UIView!
    @IBOutlet weak var submitLabel: UILabel!
    
    
    // MARK: - class variables
    var answerArray: [Int] = []
    var theFirstFactor: Int = 0
    var thePreviousFactor: Int = 0
    let maxFactor = 20
    let minFactor = 1
    var currentRow = 0
    var amountOfDraggedNumber: Int = 0
    var arrayOfSecondFactor: [Int] = Array(1...10)
    
    // MARK: - variable for pan-gesture handling
    var originPositionOfButtons: [CGPoint] = []
    var originPoint: CGPoint!
    var hoveringIndexPath: IndexPath? = nil
    
    
    // MARK: - LOTTIE ANIMATION
    let submitButtonView = LOTAnimationView(name: "submit")
    let confetti = LOTAnimationView(name: "confetti")
    
    // MARK: - START...
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initilizeForTheFirstTime()
    }
    
    override func viewDidLayoutSubviews() {
        // custom speaking_row
        speakingRow.layer.borderWidth = 1.5
        speakingRow.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        speakingRow.layer.cornerRadius = 20
        speakingRow.isHidden = true
        
        self.labelForDragging.layer.cornerRadius = self.labelForDragging.frame.width / 2
        self.labelForDragging.layer.masksToBounds = true
        self.labelForDragging.layer.zPosition = 1.0
        self.multiplicationTableView.layer.zPosition = 0.0
        self.labelForDragging.isHidden = true
    }
    
    // MARK: - INIT
    
    
    func initilizeForTheFirstTime() {
        self.pickTheFirstFactor()
        self.fetchAnswerData()
        self.assignArrayValueToButton()
        self.getOriginFrameOfButton()
        self.generateButtonsGesture()
        self.createAnimationView()
    }
    
    func createAnimationView() {
        // submit
        self.submitButtonView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        submitButtonView.contentMode = .scaleAspectFit
        self.submitView.addSubview(submitButtonView)
        self.submitButtonView.center = CGPoint(x: submitView.frame.width / 2, y: submitView.frame.height / 2)
        self.submitView.isHidden = true
        self.submitLabel.alpha = 0.0
        
        // confetti
        self.confetti.frame = self.confettiView.frame
        confetti.contentMode = .scaleAspectFill
        self.confettiView.addSubview(confetti)
        self.confetti.center = CGPoint(x: confettiView.frame.width / 2, y: confettiView.frame.height / 2)
        confettiView.isHidden = true
    }
    
    func getOriginFrameOfButton() {
        for button in answerButtons {
            self.originPositionOfButtons.append(button.frame.origin)
        }
    }
    
    func generateButtonsGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleSubmit(_:)))
        self.submitButtonView.addGestureRecognizer(tap)
        
        for button in answerButtons {
            UIView.animate(withDuration: 0.3) {
                if let offset = self.answerButtons.index(where: { $0.tag == button.tag }) {
                    button.frame.origin = self.originPositionOfButtons[offset]
                }
            } // end uiview
            
            self.addPanGesture(to: button)
            
        } // end for
    }
    
    // MARK: - Custom functions
    
    func isTrue(firstFactor: Int, secondFactor: Int, res: Int) -> Bool {
        if firstFactor * secondFactor == res {
            return true
        }
        return false
    }
    
    
    @objc func handleSubmit(_ sender: Any) {
        submitButtonView.isUserInteractionEnabled = false
        var everythingCorrect = true
        for row in 0...9 {
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.multiplicationTableView.cellForRow(at: indexPath) as! MultiPracticeTableViewCell
            
            if let twoFactors = cell.TwoFactors, let result = cell.intResult {
                let factor_1 = twoFactors.0
                let factor_2 = twoFactors.1
                if !isTrue(firstFactor: factor_1, secondFactor: factor_2, res: result) {
                    MusicHelper.shared.play(name: "level_failed")
                    UIView.animate(withDuration: 0.3) {
                        cell.rightContainer.backgroundColor = #colorLiteral(red: 1, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
                        cell.leftContainer.backgroundColor = #colorLiteral(red: 1, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
                        cell.equalSign.textColor = #colorLiteral(red: 1, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
                        everythingCorrect = false
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        cell.rightContainer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                        cell.leftContainer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                        cell.equalSign.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    }
                }
            } // end iflet
        } // end for
        
        if everythingCorrect {
            MusicHelper.shared.play(name: "correct")
            self.amountOfDraggedNumber = 0
            self.confettiView.isHidden = false
            self.confetti.play { (ok) in
                if ok {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.pickTheFirstFactor()
                        self.fetchAnswerData()
                        self.assignArrayValueToButton()
                        self.generateButtonsGesture()
                        self.createAnimationView()
                        self.multiplicationTableView.reloadData()
                    } // end dispatchQueue
                } // end if
            } // end play
        } // end if
    }
    
    func updateCell(at indexPath: IndexPath) {
        
        // determine rect of cell at indexPath in superview
        let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
        
        // add the speaking row uiview to this cell
        self.speakingRow.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.speakingRow.frame.origin = rectOfCellInSuperview.origin
        }
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
                
                // get location of pan
                let positionOfPan = sender.location(in: self.multiplicationTableView)
                
                // get index of the cell at the position of the pan
                self.hoveringIndexPath = self.multiplicationTableView.indexPathForRow(at: positionOfPan)
                
                if let indexPath = hoveringIndexPath {
                    
                    // set initial position of speaking row
                    if speakingRow.isHidden {
                        let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
                        let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
                        speakingRow.frame.origin = rectOfCellInSuperview.origin
                        speakingRow.isHidden = false
                    }
                    
                    self.updateCell(at: indexPath)
                } else {
                    speakingRow.isHidden = true
            }

            case .ended: // >>> lift up the finger
                
                // turn off the speaking row
                speakingRow.isHidden = true
                
                // get location of pan
                let positionOfPan = sender.location(in: self.multiplicationTableView)

                // get index of the cell at the position of the pan
                let indexPath = self.multiplicationTableView.indexPathForRow(at: positionOfPan)
                
                if let indexPath = indexPath {
                    MusicHelper.shared.play(name: "button_click")
                    
                    let cell = self.multiplicationTableView.cellForRow(at: indexPath) as! MultiPracticeTableViewCell
                    
                    // haven't picked yet
                    if !cell.isAlreadyChoosen {
                        numberView.alpha = 0 // hide numberView
                        cell.intResult = numberView.tag // set value to label
                        cell.isAlreadyChoosen = true // set cell's isAlreadyChoosen
                        self.amountOfDraggedNumber += 1
                    
                    } else { // already picked
                        // exchange values of 2 buttons
                        guard let res = cell.intResult else { return }
                        let temp = res
                        cell.intResult = numberView.tag
                        numberView.tag = temp
                        (numberView as! UIButton).setTitle("\(numberView.tag)", for: .normal)
                        
                        // turn back to the position of the other
                        if let offset = self.answerButtons.index(where: { $0.tag == numberView.tag }) {
                            numberView.frame.origin = self.originPositionOfButtons[offset]
                        }
                    }
                    
                } else {
                    // number being dragged turn back the original position
                    UIView.animate(withDuration: 0.3) {
                        if let offset = self.answerButtons.index(where: { $0.tag == numberView.tag }) {
                            numberView.frame.origin = self.originPositionOfButtons[offset]
                        }
                    } // end uiview
                }
                
                self.hoveringIndexPath = nil
            
            default:
                break
        } // end switch
        
        // show submit button
        if self.amountOfDraggedNumber == 10 {
            self.submitView.isHidden = false
            self.submitButtonView.play { (ok) in
                if ok {
                    self.submitView.bringSubviewToFront(self.submitLabel)
                    self.submitLabel.center = self.submitButtonView.center
                    UIView.animate(withDuration: 0.2, animations: {
                        self.submitLabel.alpha = 1.0
                    })
                } // end if ok
            } // end completion
        } // end if
        
    }
    
    private func pickTheFirstFactor() {
        while theFirstFactor == thePreviousFactor {
            self.theFirstFactor = Int.random(in: 1...20)
        } // end while
        self.thePreviousFactor = self.theFirstFactor
        
        self.arrayOfSecondFactor.shuffle()
        
    }
    
    private func fetchAnswerData() {
        answerArray.removeAll()
        for i in 1...10 {
            answerArray.append(self.theFirstFactor * i)
        } // end for
        answerArray.shuffle()
    }
    
    
    private func assignArrayValueToButton() {
        for button in answerButtons {
            button.alpha = 1
            button.addShadowTitle()
            button.layer.zPosition = 1.0
            button.layer.cornerRadius = button.frame.width / 2
            
            button.setTitle("\(answerArray[answerButtons.index(of: button)!])", for: [])
            button.tag = answerArray[answerButtons.index(of: button)!]
        } // end for
    }
    
    
    // MARK: - IBAction class
    @IBAction func answerPicked(_ sender: Any) {

    }
}


extension PracticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.multiplicationTableView.dequeueReusableCell(withIdentifier: Constant.CellID.multiplyCell, for: indexPath) as! MultiPracticeTableViewCell
        
        cell.TwoFactors = (theFirstFactor, self.arrayOfSecondFactor[indexPath.row])
        cell.intResult = nil
        cell.isAlreadyChoosen = false
        cell.delegate = self
        
        cell.tag = indexPath.row
        cell.superViewController = self
        return cell
    }
    
}

extension PracticeViewController: PanGestureInCellDelegate {
   
    func panStart(gesture: UIPanGestureRecognizer, resultLabel: String, indexPathOfCurrentCell: IndexPath, frameOfLabel: CGRect) {
        
        let numberView = gesture.view!
        self.view.bringSubviewToFront(numberView)
        
        let oldCell = self.multiplicationTableView.cellForRow(at: indexPathOfCurrentCell) as! MultiPracticeTableViewCell
        
        if gesture.state == .began || gesture.state == .changed {
            
            // moving
            let translation = gesture.translation(in: self.view)
            numberView.center = CGPoint(x: numberView.center.x + translation.x, y: numberView.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
            
            // get position of pan
            let positionOfPan = gesture.location(in: self.multiplicationTableView)
            
            // create temperary label for dragging
            labelForDragging.isHidden = false
            var tempFrame = labelForDragging.frame
            tempFrame.origin.x = positionOfPan.x + labelForDragging.frame.width / 2
            tempFrame.origin.y = positionOfPan.y - labelForDragging.frame.height / 2
            labelForDragging.frame = tempFrame
            labelForDragging.text = resultLabel
            
            self.hoveringIndexPath = self.multiplicationTableView.indexPathForRow(at: positionOfPan)
            
            if let indexPath = hoveringIndexPath {
                
                // set initial position of speaking row
                if speakingRow.isHidden {
                    let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
                    let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
                    speakingRow.frame.origin = rectOfCellInSuperview.origin
                    speakingRow.isHidden = false
                }
                
                self.updateCell(at: indexPath)
            } else {
                speakingRow.isHidden = true
            }
            
            
        } else if gesture.state == .ended {
            speakingRow.isHidden = true
            
            let positionOfPanInTableView = gesture.location(in: self.multiplicationTableView)
            // get index of the cell at the position of the pan
            let indexPath = self.multiplicationTableView.indexPathForRow(at: positionOfPanInTableView)
            
            if let indexPath = indexPath {
                submitButtonView.isUserInteractionEnabled = true
                MusicHelper.shared.play(name: "button_click")
                
                let newCell = self.multiplicationTableView.cellForRow(at: indexPath) as! MultiPracticeTableViewCell
                
                // exchange result's value of cell
                let tempLabel = newCell.intResult
                newCell.intResult = oldCell.intResult
                oldCell.intResult = tempLabel
                
                self.labelForDragging.isHidden = true
                oldCell.result.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    oldCell.result.frame = newCell.result.frame
                }
                
            } else {
                self.labelForDragging.isHidden = true
                oldCell.result.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    oldCell.result.frame = oldCell.originPositionOfResultLabel
                }
                
            }
        } // end if
    }
    
   
}
