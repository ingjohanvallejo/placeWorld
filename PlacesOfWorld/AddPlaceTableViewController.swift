//
//  AddPlaceTableViewController.swift
//  PlacesOfWorld
//
//  Created by Johan Vallejo on 8/11/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit
import CoreData

class AddPlaceTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var webSiteTextField: UITextField!
    @IBOutlet var greatButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!

    var rating :String?
    var place : Place?
    let defaultColor = UIColor(red: 12.0/255.0, green: 207.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    let selectedColor = UIColor.blue
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        self.typeTextField.delegate = self
        self.addressTextField.delegate = self
        self.phoneTextField.delegate = self
        self.webSiteTextField.delegate = self


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //Se valida de que todos los campos contengan información
        if let name = self.nameTextField.text,
            let type = self.typeTextField.text,
            let address = self.addressTextField.text,
            let phone = self.phoneTextField.text,
            let webSite = self.webSiteTextField.text,
            let theImage = self.imageView.image,
            let rating = self.rating {
            
            //Se relaciona la BD de CoreData con la app, por medio del AppDelegate
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                let context = container.viewContext
                self.place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place
                //Se llenan los campos uno a uno 
                self.place?.name = name
                self.place?.type = type
                self.place?.location = address
                self.place?.phone = phone
                self.place?.webSite = webSite
                self.place?.rating = rating
                
                self.place?.image = UIImagePNGRepresentation(theImage) as NSData?
                
                do {
                    try context.save()
                } catch {
                    print("Ocurrio un error al guardar en CoreData")
                }
            }

            self.performSegue(withIdentifier: "unwindToMainViewController", sender: self)

        } else {
            //En caso de que no se llenen todos los campos se le muestra un mensaje que lo indique
            let alertController = UIAlertController(title: "Falta Algún Dato", message: "Revisa que tengas todo configurado", preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAlert)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func ratingPressed(_ sender: UIButton) {
        //Se cambia de color el boton seleccionado
        switch sender.tag {
        case 1:
            self.rating = "great"
            self.greatButton.backgroundColor = selectedColor
            self.goodButton.backgroundColor = defaultColor
            self.dislikeButton.backgroundColor = defaultColor
        case 2:
            self.rating = "good"
            self.greatButton.backgroundColor = defaultColor
            self.goodButton.backgroundColor = selectedColor
            self.dislikeButton.backgroundColor = defaultColor
        case 3:
            self.rating = "dislike"
            self.greatButton.backgroundColor = defaultColor
            self.goodButton.backgroundColor = defaultColor
            self.dislikeButton.backgroundColor = selectedColor
        default:
            break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //Se importa las fotos de la libreria
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        //Se definen las restricciones por código para que la imagen se muestre ocupando to-do el espacio
        let leadingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.imageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true

        let bottomConstraint = NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.imageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true

        dismiss(animated: true, completion: nil)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
