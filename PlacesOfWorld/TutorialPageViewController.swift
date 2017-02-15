//
//  TutorialPageViewController.swift
//  PlacesOfWorld
//
//  Created by Johan Vallejo on 10/11/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    var tutorialStep : [TutorialStep] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Se llena la información de los pasos del tutorial
        let firstStep = TutorialStep(index: 0, titleName: "Personalizada", content: "Crea Nuevos lugares, sube imagenes y úbicalos con solo unos pocos segundos", image: #imageLiteral(resourceName: "tuto-intro-1"))
        self.tutorialStep.append(firstStep)
        
        let secondStep = TutorialStep(index: 1, titleName: "Encuentra", content: "Ubica y encuentra tus lugares favoritos po medio del mapa", image: #imageLiteral(resourceName: "tuto-intro-2"))
        self.tutorialStep.append(secondStep)
        
        let thirdStep = TutorialStep(index: 2, titleName: "Descubre", content: "Descubre lugares increibles cerca de ti y compartelos con tus amigos", image: #imageLiteral(resourceName: "tuto-intro-3"))
        self.tutorialStep.append(thirdStep)
        
        dataSource = self
        if let startVC = self.pageViewController(atIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func forward(toIndex: Int) {
        if let nextVC =  self.pageViewController(atIndex: toIndex + 1) {
            self.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
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

extension TutorialPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! TutorialContentViewController).tutorialStep.index
        index += 1
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).tutorialStep.index
        index -= 1
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(atIndex: Int) -> TutorialContentViewController? {
        if atIndex == NSNotFound || atIndex < 0 || atIndex >=  self.tutorialStep.count {
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialPageContent") as? TutorialContentViewController {
            pageContentViewController.tutorialStep = self.tutorialStep[atIndex]

            return pageContentViewController
        }

        return nil
    }
    
    //Se configuran los metodos para que se muestren los puntos inferiores  que indican en que pagina esta 
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.tutorialStep.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "TutorialPageContent") as? TutorialContentViewController {
            if let tutorialStepCurrent = pageContentVC.tutorialStep {
                return tutorialStepCurrent.index
            }
        }

        return 0
    }
 */
    
}
