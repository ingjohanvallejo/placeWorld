//
//  TutorialContentViewController.swift
//  PlacesOfWorld
//
//  Created by Johan Vallejo on 10/11/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageContentView: UIImageView!
    @IBOutlet var descriptionContentLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton!
    
    var tutorialStep : TutorialStep!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.titleLabel.text = self.tutorialStep.titleName
        self.imageContentView.image = self.tutorialStep.image
        self.descriptionContentLabel.text = self.tutorialStep.content
        self.pageControl.currentPage = self.tutorialStep.index
        
        switch self.tutorialStep.index {
        case 0...1:
            self.nextButton.setTitle("Siguiente", for: .normal)
        case 2:
            self.nextButton.setTitle("Finalizar", for: .normal)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        switch self.tutorialStep.index {
        case 0...1:
            let pageViewController = parent as! TutorialPageViewController
            pageViewController.forward(toIndex: self.tutorialStep.index)
        case 2:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewTutorial")
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
