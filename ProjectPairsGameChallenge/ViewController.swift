//
//  ViewController.swift
//  ProjectPairsGameChallenge
//
//  Created by Ana Caroline de Souza on 01/04/20.
//  Copyright © 2020 Ian e Leo Corp. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    var buttoms = [UIButton]()
    var tagControl = 0
    var firstChoice : Int? = nil
    var secondChoice : Int? = nil
    
    var scoreLabel: UILabel!
    var scoreLabelCancellable: AnyCancellable?
    var viewModel = ScoreViewModel()
    
    var score : Int! {
        didSet {
            scoreLabel.text = "\(viewModel.score) left to pair!"
        }
    }
    
    var cardsImages = ["card1","card3","card1","card2","card2","card3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(resetGame))
        
        view.backgroundColor = .red
        
        cardsImages.shuffle()
        
        for col in 0..<3 {
            for row in 0..<2 {
                createButtom(x: CGFloat(80+(row*140)), y: CGFloat(130+(col*150)))
            }
        }
        
        scoreLabel = UILabel(frame: CGRect(x: 50, y: 600, width: 400, height: 200))
        scoreLabel.font = UIFont(name: "Times new roman", size: 40)
        
        scoreLabelCancellable = viewModel.$score.receive(on: DispatchQueue.main).assign(to: \.score, on: self)
        
        view.addSubview(scoreLabel)
        
        score = viewModel.score
    }
    
    @objc func resetGame() {
        
        cleanChoices()
        cleanBoard()
        cleanScore()
        
    }
    
    func cleanScore() {
        viewModel.resetScore()
    }
    
    func cleanBoard() {
        
        buttoms.shuffle()
        
        for tag in 0..<buttoms.count {
            let buttom = buttoms[tag]
            buttom.alpha = 1
            buttom.isEnabled = true
            buttom.setImage(UIImage(named: "back"), for: .normal)
            buttom.transform = .identity
            buttom.tag = tag
        }
    }
    
    func createButtom(x: CGFloat, y: CGFloat){
        
        let buttom = UIButton(frame: CGRect(x: x, y: y, width: 130, height: 130))
        buttom.setImage(UIImage(named: "back"), for: .normal)
        buttom.addTarget(self, action: #selector(cardSelected), for: .touchUpInside)
        buttom.tag = tagControl
        view.addSubview(buttom)
        buttoms.append(buttom)
        tagControl+=1
    }
    
    fileprivate func cardFlip(tag: Int, withImage imageName: String) {
        buttoms[tag].setImage(UIImage(named: imageName), for: .normal)
        UIView.transition(with: buttoms[tag], duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    fileprivate func cleanChoices() {
        firstChoice = nil
        secondChoice = nil
    }
    
    fileprivate func isGameOver() -> Bool {
        return viewModel.score == 0
    }
    
    fileprivate func isGameEnded() {
        if isGameOver()  {
            let ac = UIAlertController(title: "WE ARE THE CHAMPIOONNSSS!", message: "You finally completed the 100 days of Swift, CONGRATULATIONS BOOYYY!!!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "YEAH!!!", style: .default))
            present(ac,animated: true)
        }
    }
    
    fileprivate func makePairsDisappear() {
        buttoms[firstChoice!].isEnabled = false
        buttoms[secondChoice!].isEnabled = false
        
        UIView.animate(withDuration: 3, delay: 0, options: [], animations: {
            [weak self] in
            guard let first = self?.firstChoice else { return }
            guard let second = self?.secondChoice else { return }
            self?.buttoms[first].alpha = 0
            self?.buttoms[second].alpha = 0
        })
    }
    
    fileprivate func userSelectedEqualImages() -> Bool {
        return cardsImages[firstChoice!] == cardsImages[secondChoice!]
    }
    
    fileprivate func flipTwoCardsToBack() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            [weak self] in
            guard let first = self?.firstChoice else { return }
            guard let second = self?.secondChoice else { return }
            
            self?.cardFlip(tag: first, withImage: "back")
            self?.cardFlip(tag: second, withImage: "back")
            
            self?.cleanChoices()
            
        }
    }
    
    fileprivate func isFirstCard() -> Bool {
        return firstChoice == nil
    }
    
    fileprivate func isSecondCard(_ sender: UIButton) -> Bool {
        return secondChoice == nil && sender.tag != firstChoice!
    }
    
    @objc func cardSelected(sender: UIButton) {
        
        if isFirstCard() {
            cardFlip(tag: sender.tag, withImage: cardsImages[sender.tag])
            firstChoice = sender.tag
            
        } else if isSecondCard(sender){
            cardFlip(tag: sender.tag, withImage: cardsImages[sender.tag])
            secondChoice = sender.tag
            
            if userSelectedEqualImages() {
                
                viewModel.reduceScore()
                makePairsDisappear()
                cleanChoices()
                isGameEnded()
                
            } else {
                flipTwoCardsToBack()
            }
        }
    }
    
    
}

