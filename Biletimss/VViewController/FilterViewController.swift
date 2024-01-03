//
//  FilterViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var cinemaButton: UIButton!
    @IBOutlet weak var tiyatroButton: UIButton!
    @IBOutlet weak var workshopButton: UIButton!
    @IBOutlet weak var sporButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen

        
    }
    
    @IBAction func buttonPressedAlter(_ sender: Any) {
        let popupMessage = "This function has not been implemented yet"
        
        let alertController = UIAlertController(title: "Uyarı", message: popupMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title:" Tamam", style: .default , handler:  nil)
        alertController.addAction(okAction)
        
        present(alertController ,animated: true, completion: nil)
    }
    
    @IBAction func cinemaPressed(_ sender: Any) {
        performSegue(withIdentifier: "filterSegue", sender: sender)
    }
    
    
    
}
