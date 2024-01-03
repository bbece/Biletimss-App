//
//  QrTicketViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit

class QrTicketViewController: UIViewController {
    var generatedQRImage: UIImage?
   
    
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        qrImage.image = generatedQRImage
        qrLabel.textColor = .green
        qrLabel.text = "Biletiniz Oluşturuldu!!"
        
       /* if let image = generatedQRImage {
                qrImage.image = image
            
                // Eğer başarılı bir şekilde QR resmi yüklendiyse, burada diğer işlemleri yapabilirsiniz.
            } else {
                // QR resmi yüklenemedi, ekranda "Payment Error" yazısını gösterin.
                qrLabel.textColor = .red
                qrLabel.text = "Payment Error"
            }*/


        // Do any additional setup after loading the view.
    }
    
 


}
