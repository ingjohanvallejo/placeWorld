//
//  ViewController.swift
//  Cooking
//
//  Created by Johan Vallejo on 25/10/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    //Se crea el array para las recetas
    var places: [Place] = []
    var searchResults : [Place] = []
    var fetchResultsController : NSFetchedResultsController<Place>!
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        //Buscador
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Find Place"
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.barTintColor = UIColor.green
        

        //Se obtiene la información de la Base de Datos CoreData y se actualiza cuando se presente un cambio
        let fetchRequest : NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                self.places = fetchResultsController.fetchedObjects!

                //forma de cargar la informcion inicial con User Default
                let defaults = UserDefaults.standard
                if !defaults.bool(forKey: "hasLoadedDefaultInfo") {
                    self.loadDefaultData()
                    defaults.set(true, forKey: "hasLoadedDefaultInfo")
                }
                
                /*forma de cargar la informacion inicial de fomra manual
                 if self.places.count < 8 {
                    self.loadDefaultData()
                }*/
            } catch {
                print("No Se pudo actualizar el contenido \(error)")
            }
        }

        //Se obtiene la información de la Base de Datos CoreData
        /*if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            let request : NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            //let request : NSFetchRequest<Place> = Place.fetchRequest()

            do {
                self.places = try context.fetch(request)
            } catch {
                print("No se pudo conseguir al inforamción \(error)")
            }
            
        }*/
        
        /*var place = Place(name: "Alexanderplatz", type: "Square", location: "Alexanderstraße 4 10178 Berlin Deutschland", phone: "49 30 2404763", webSite: "alexgastro.de", image: #imageLiteral(resourceName: "alexanderplatz"))
        places.append(place)
        */
    }
    
    func loadDefaultData() {

        let names = ["Alexanderplatz", "Atomium", "Big Ben", "Cristo Redentor", "La Seu de Mallorca", "La Gran Muralla China", "Torre Eiffel", "Torre de Pisa"]
        let types = ["Square", "Museum", "Monument", "Monument", "Cathedral", "Monument", "Monument", "Monument"]
        let locations = ["Alexanderstraße 4 10178 Berlin Deutschland", "Atomiumsquare 1 1020 Bruxelles België", "London SW1A 0AA England", "Cristo Redentor João Pessoa - PB Brasil", "La Seu Plaza de la Seu 5 07001 Palma Baleares, España", "Great Wall, Mutianyu, Beijin China", "5 Avenue Anatole France 75007 Paris France", "Torre di Pisa 56126 Pisa Italia"]
        let phones = ["49 30 2404763", "49 30 2404763", "49 30 2404763", "49 30 2404763", "49 30 2404763", "49 30 2404763", "49 30 2404763", "49 30 2404763"]
        let webs = ["http://alexgastro.de", "http://atomium.be/", "https://en.wikipedia.org/wiki/Big_Ben", "https://en.wikipedia.org/wiki/Christ_the_Redeemer_(statue)", "http://catedraldemallorca.info/principal/en", "http://www.21wonders.es/historia/historia-muralla-china/", "https://www.paris.es/torre-eiffel", "http://historiaybiografias.com/torre_pisa/"]
        let images = [#imageLiteral(resourceName: "alexanderplatz"), #imageLiteral(resourceName: "atomium"), #imageLiteral(resourceName: "bigben"), #imageLiteral(resourceName: "cristoredentor"), #imageLiteral(resourceName: "mallorca"), #imageLiteral(resourceName: "murallachina"), #imageLiteral(resourceName: "torreeiffel"), #imageLiteral(resourceName: "torrepisa")]
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            //Se llenan los campos uno a uno
            for i in 0..<names.count {
                let place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place
                place?.name = names[i]
                place?.type = types[i]
                place?.location = locations[i]
                place?.phone = phones[i]
                place?.webSite = webs[i]
                place?.rating = "rating"
                place?.image = UIImagePNGRepresentation(images[i]) as NSData?
                
                do {
                    try context.save()
                } catch {
                    print("Ocurrio un error al guardar en CoreData")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Se oculta la barra superior
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Se oculta el navigation controller cuando se hace Swipe en la pantalla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
        let hasViewTutorial =  defaults.bool(forKey: "hasViewTutorial")
        
        if hasViewTutorial {
            return
        }

        if let pagVC = storyboard?.instantiateViewController(withIdentifier: "TutorialController") as? TutorialPageViewController {
            self.present(pagVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDataSource
    
    //Se divide la tabla en una sola sección
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Se envia la cantidad de elementos que va tener la tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchResults.count
        } else {
            return self.places.count
        }
    }
    
    //Se configura la celda de la tabla
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place : Place!
        
        if self.searchController.isActive {
            place = self.searchResults[indexPath.row]
        } else {
            place = self.places[indexPath.row]
        }
        
        let cellId = "PlaceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlaceCell
        cell.imagePlace.image = UIImage(data: place.image! as Data)
        cell.namePlace.text = place.name
        cell.typePlace.text = place.type
        cell.locationPlace.text = place.location

        return cell
    }

    //MARK - UITableViewDelegate
    
    //Se agregan las opciones de Compartir y Borrar al menú que se despliega al hacer swipe en la celda
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //comparitr
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let place : Place!

            if self.searchController.isActive {
                place = self.searchResults[indexPath.row]
            } else {
                place = self.places[indexPath.row]
            }

            let shareDefaultText = "Estoy visitando el lugar \(place.name) en la App Place Of Wolrd"
            let activityController = UIActivityViewController(activityItems: [shareDefaultText, UIImage(data: place.image! as Data)!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            
        }
        
        shareAction.backgroundColor = UIColor(red: 30.0/255.0, green: 164.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        //Borrar
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                let context = container.viewContext
                let placeToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(placeToDelete)
                
                do {
                    try context.save()
                } catch {
                    print("No se ha podido borrar \(error)")
                }
            }
            /*self.places.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)*/
        }
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    //Se prepara y envian la información a la siguiente vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let place : Place!
                
                if self.searchController.isActive {
                    place = self.searchResults[indexPath.row]
                } else {
                    place = self.places[indexPath.row]
                }
                let detinationViewController = segue.destination as! DetailViewController
                detinationViewController.place = place
                detinationViewController.hidesBottomBarWhenPushed = true
            }
        }
    }

    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToMainViewController" {
            if let addPlaceVC = segue.source as? AddPlaceTableViewController {
                if let newPlace = addPlaceVC.place {
                    self.places.append(newPlace)
                }
            }
        }
    }

    //Filtrar el contenido del array de lugares
    func filterContentFor(textToSearch: String) {
        self.searchResults = self.places.filter({ (place) -> Bool in
            let nameToFind = place.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            let typeToFind = place.type.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return (nameToFind != nil) || (typeToFind != nil)
        })
    }
}

//extension del delegado para que se actualice la fila cada vezq eu se ejecute un cambio sobre ella
extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        /*default:
            self.tableView.reloadData()*/
        }
        
        self.places = controller.fetchedObjects as! [Place]
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
}
