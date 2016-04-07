//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Pierre Branéus on 2014-06-26.
//  Copyright (c) 2014 Pierre Branéus. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    var scene: GameScene!


    override func prefersStatusBarHidden() -> Bool  {
        return true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        //Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false

        //Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        onLevel = 0
        goLevel()
        
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.hidden = true
        shuffleButton.hidden = true

        //Present the scene.
        skView.presentScene(scene)
        scene.removeAllTilesSprites()
        
        // Load and star background music.
        let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
        backgroundMusic = AVAudioPlayer(contentsOfURL: url, error: nil)
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        
        beginGame()
    }
    
    var level: Level!
    
    func goLevel() {
        level = Level(filename: "Level_\(onLevel)")
        scene.level = level
        scene.addTiles()
    }
    
    func beginGame() {
        goLevel()
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
        
        scene.animateBeginGame() {
            self.shuffleButton.hidden = false
        }
        shuffle()
    }
    
    func shuffle() {
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }
    
    func handleSwipe (swap: Swap) {
        view.userInteractionEnabled = false
        
        if  level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        // TODO: do something with the chains set
        
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(chains) {
            
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns) {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns) {
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn() {
        decrementMoves()
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
    }
    
    var movesLeft: Int = 0
    var score: Int = 0
    
    @IBOutlet var targetLabel: UILabel
    @IBOutlet var movesLabel: UILabel
    @IBOutlet var scoreLabel: UILabel
    @IBOutlet var gameOverPanel: UIImageView
    @IBOutlet var shuffleButton: UIButton
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    func updateLabels() {
        targetLabel.text = NSString(format: "%ld", level.targetScore)
        movesLabel.text = NSString(format: "%ld", movesLeft)
        scoreLabel.text = NSString(format: "%ld", score)
    }
    
    func decrementMoves() {
        --movesLeft
        updateLabels()
        
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            if onLevel < 6 {
            ++onLevel
            }
            showGameOver()
        }else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver() {
        gameOverPanel.hidden = false
        shuffleButton.hidden = true
        scene.userInteractionEnabled = false
        scene.removeAllTilesSprites()
        
        scene.animateGameOver() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        beginGame()
    }
    
    @IBAction func shuffleButtonPressed(AnyObject) {
        shuffle()
        decrementMoves()
    }
    
    var backgroundMusic: AVAudioPlayer!
    var onLevel: Int = 0
}

