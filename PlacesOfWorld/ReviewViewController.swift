//
//  ReviewViewController.swift
//  Cooking
//
//  Created by Johan Vallejo on 28/10/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
    
    var ratingSelected : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Efecto Blurr
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //Esconder el rating
        ratingStackView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        //Combinar escalado con traslación 
        /*let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translation = CGAffineTransform(translationX: 0.0, y: 500.0)
        ratingStackView.transform = scale.concatenating(translation)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Animación para rating
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        */
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: { 
                self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ratingPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            ratingSelected = "dislike"
        case 2:
            ratingSelected = "good"
        case 3:
            ratingSelected = "great"
        default:
            break
        }
        
        performSegue(withIdentifier: "unwindToDetailView", sender: sender)
        
    }

}
