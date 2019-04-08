//
//  MultiplicationTableViewController.swift
//  MathTables
//
//  Created by TinhPV on 3/5/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import AVFoundation

class LearnViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var multiplicationTableView: UITableView!
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var speakingRow: UIView!
    
    
    // MARK: - other variables
    var theFirstFactor: Int = 1
    let maxFactor = 20
    let minFactor = 1
    var doSpeakSequentially = false
    var currentSelectedRow = 0
    var originRectOfReadingView: CGPoint!
    
    // MARK: - AVFoundation
    let synthesizer = AVSpeechSynthesizer()

    // MARK: - START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.synthesizer.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        speakingRow.layer.borderWidth = 1.5
        speakingRow.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        speakingRow.layer.cornerRadius = 20
        speakingRow.isHidden = true
    }
    
    // MARK: - custom function
    private func initView() {
        //self.numberOfTable.text = "\(theFirstFactor)"
        self.speakButton.setImage(UIImage(named: "speak"), for: .normal)
        self.speakButton.setImage(UIImage(named: "pause"), for: .selected)
    }
    
    
    private func speakWord(wordForSpeech: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: wordForSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    
    private func manuallySelectRow(at indexPath: IndexPath) {
        
        let textToSpeech = "\(theFirstFactor) \(indexPath.row + 1) \(theFirstFactor * (indexPath.row + 1))"
        self.speakWord(wordForSpeech: textToSpeech)
        
        let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
        
        UIView.animate(withDuration: 0.3) {
            self.speakingRow.frame.origin = rectOfCellInSuperview.origin
        }
    }
    
    private func showReadingView(at indexPath: IndexPath) {
        let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
        self.speakingRow.frame = rectOfCellInSuperview
        self.speakingRow.isHidden = false
    }
    
    private func getInitialOriginFrameOfReadingView() {
        let indexPath = IndexPath(row: 0, section: 0)
        let rectOfCellInTableView = self.multiplicationTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = multiplicationTableView.convert(rectOfCellInTableView, to: multiplicationTableView.superview)
        self.originRectOfReadingView = rectOfCellInSuperview.origin
    }
    
    
    // MARK: - IBAction function
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardID.mainViewController) as! MainViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.theFirstFactor += 1
        if self.theFirstFactor > self.maxFactor {
            self.theFirstFactor = 1
        }
        self.multiplicationTableView.reloadData()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        self.theFirstFactor -= 1
        if self.theFirstFactor < self.minFactor {
            self.theFirstFactor = 20
        }
        self.multiplicationTableView.reloadData()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func speakButtonTapped(_ sender: Any) {
        self.speakButton.isSelected = !self.speakButton.isSelected
        
        if doSpeakSequentially { // if being speaking then stop it
            self.doSpeakSequentially = false
            self.synthesizer.stopSpeaking(at: .immediate)
            self.multiplicationTableView.reloadData()
            self.speakingRow.isHidden = true
        } else { // Otherwise, prepare to start
            self.doSpeakSequentially = true
            self.currentSelectedRow = 0
            let indexPath = IndexPath(row: currentSelectedRow, section: 0)
            self.speakingRow.isHidden = false
            self.getInitialOriginFrameOfReadingView()
            self.manuallySelectRow(at: indexPath)
        } // end if
    } // end method

}


extension LearnViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.multiplicationTableView.dequeueReusableCell(withIdentifier: Constant.CellID.multiplyCell, for: indexPath) as! MultiplicationTableViewCell
        cell.TwoFactors = (theFirstFactor, indexPath.row + 1)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showReadingView(at: indexPath)
        let textToSpeech = "\(theFirstFactor) \(indexPath.row + 1) \(theFirstFactor * (indexPath.row + 1))"
        self.speakWord(wordForSpeech: textToSpeech)
        
        
    }
    
    
}


extension LearnViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if self.doSpeakSequentially {
            self.currentSelectedRow += 1
            
            if self.currentSelectedRow > 9 { // out of range
                self.doSpeakSequentially = false
                self.synthesizer.stopSpeaking(at: .immediate)
                self.multiplicationTableView.reloadData()
            } else { // otherwise, ....
                let indexPath = IndexPath(row: currentSelectedRow, section: 0)
                self.manuallySelectRow(at: indexPath)
            } // end if
            
        } else {
            self.speakingRow.isHidden = true
        }
        
        
    }
}
