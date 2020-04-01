//
//  ViewController.swift
//  ProjectPairsGameChallenge
//
//  Created by Ana Caroline de Souza on 01/04/20.
//  Copyright © 2020 Ian e Leo Corp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var buttoms = [UIButton]()
    var tagControl = 0
    var firstChoice : Int? = nil
    var secondChoice : Int? = nil
    
    var cardsImages = ["card1","card3","card1","card2","card2","card3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        cardsImages.shuffle()
        
        for col in 0..<3 {
            for row in 0..<2 {
                createButtom(x: CGFloat(80+(row*140)), y: CGFloat(130+(col*150)))
            }
        }
        
    }
    
    func createButtom(x: CGFloat, y: CGFloat){
        
        let buttom = UIButton(frame: CGRect(x: x, y: y, width: 130, height: 130))
        buttom.setImage(UIImage(named: "back"), for: .normal)
        buttom.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        buttom.tag = tagControl
        view.addSubview(buttom)
        buttoms.append(buttom)
        tagControl+=1
    }
    
    fileprivate func buttomFlip(tag: Int, withImage imageName: String) {
        let image = UIImage(named: imageName)
        buttoms[tag].setImage(image, for: .normal)
        UIView.transition(with: buttoms[tag], duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    fileprivate func cleanChoices() {
        firstChoice = nil
        secondChoice = nil
    }
    
    @objc func flipCard(sender: UIButton) {
        
        if firstChoice == nil {
            buttomFlip(tag: sender.tag, withImage: cardsImages[sender.tag])
            firstChoice = sender.tag
        } else if secondChoice == nil {
            buttomFlip(tag: sender.tag, withImage: cardsImages[sender.tag])
            secondChoice = sender.tag
            
            if cardsImages[firstChoice!] == cardsImages[secondChoice!] {
                
                buttoms[firstChoice!].isEnabled = false
                buttoms[secondChoice!].isEnabled = false
                
                UIView.animate(withDuration: 3, delay: 0, options: [], animations: {
                    [weak self] in
                    guard let first = self?.firstChoice else { return }
                    guard let second = self?.secondChoice else { return }
                    self?.buttoms[first].alpha = 0
                    self?.buttoms[second].alpha = 0
                })
                
                cleanChoices()
                
                if (buttoms.allSatisfy { $0.isEnabled == false
                }) {
                    let ac = UIAlertController(title: "WE ARE THE CHAMPIOONNSSS!", message: "You finally completed the 100 days of Swift, CONGRATULATIONS BOOYYY!!!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "YEAH!!!", style: .default))
                    present(ac,animated: true)
                }
                
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
                    [weak self] in
                    guard let first = self?.firstChoice else { return }
                    guard let second = self?.secondChoice else { return }
                    
                    self?.buttomFlip(tag: first, withImage: "back")
                    self?.buttomFlip(tag: second, withImage: "back")
                    
                    self?.cleanChoices()
                    
                }
            }
        }
    }
    
    
}

