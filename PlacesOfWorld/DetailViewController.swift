//
//  DetailViewController.swift
//  Cooking
//
//  Created by Johan Vallejo on 27/10/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

    @IBOutlet var imageDetail: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ratingButton: UIButton!
    
    var place : Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = place.name
        self.imageDetail.image = UIImage(data: self.place.image as! Data)
        //self.imageDetail.image = UIImage(data: self.place.image! as Data)
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let image = UIImage(named: self.place.rating!)
        self.ratingButton.setImage(image, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func close(segue: UIStoryboardSegue) {
        
        if let reviewVC = segue.source as? ReviewViewController {
            
            if let rating = reviewVC.ratingSelected {
                self.place.rating = rating
                let image = UIImage(named: self.place.rating!)
                self.ratingButton.setImage(image, for: .normal)
                
                if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                    let context = container.viewContext
                    do {
                        try context.save()
                    } catch  {
                        print("No se han guardado los cambios \(error)")
                    }
                }
            }
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

extension DetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailViewCell", for: indexPath) as! PlaceDetailViewCell
        
        cell.backgroundColor = UIColor.clear
        
        //Configuración de las diferentes celdas según las secciones 
        switch indexPath.row {
        case 0:
            cell.keyNameDetail.text = "Name :"
            cell.nameDetail.text = self.place.name
        case 1:
            cell.keyNameDetail.text = "Type :"
            cell.nameDetail.text = self.place.type
        case 2:
            cell.keyNameDetail.text = "Location :"
            cell.nameDetail.text = self.place.location
        case 3:
            cell.keyNameDetail.text = "Phone :"
            cell.nameDetail.text = self.place.phone
        case 4:
            cell.keyNameDetail.text = "Web Site :"
            cell.nameDetail.text = self.place.webSite
        default:
            break
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.place = self.place
        }
    }
}

extension DetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 2:
            //hemos seleccionado la celda localización
            self.performSegue(withIdentifier: "showMap", sender: nil)
        case 3:
            //Llamar o mandar SMS al telefono seleccionado 
            let alertController = UIAlertController(title: "Contact \(self.place.name)", message: "How do you want to contact the number \(self.place.phone!) ?", preferredStyle: .actionSheet)
            let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                //Lógica para llamar
                if let phoneURL = URL(string: "tel://\(self.place.phone!)") {
                    let app = UIApplication.shared

                    print(self.place.phone!)
                    if app.canOpenURL(phoneURL) {
                        app.open(phoneURL, options: [:], completionHandler: nil)
                    }
                }
            })

            let smsAction = UIAlertAction(title: "SMS", style: .default, handler: { (action) in
                //Lógica para enviar SMS
                if MFMessageComposeViewController.canSendText() {
                    let msg = "Hi, place of world"
                    let msgVC = MFMessageComposeViewController()
                    msgVC.body = msg
                    msgVC.recipients = [self.place.phone!]
                    msgVC.messageComposeDelegate = self
                    self.present(msgVC, animated: true, completion: nil)
                }
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(callAction)
            alertController.addAction(smsAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        case 4:
            //Abrir una pagina Web
            if let webSite = URL(string: self.place.webSite!) {
                let app = UIApplication.shared
                
                if app.canOpenURL(webSite) {
                    app.open(webSite, options: [:], completionHandler: nil)
                }

            }
        default:
            break
        }
    }
    
}

extension DetailViewController : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        print(result)
    }
}
