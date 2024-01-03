//
//  PaymentViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate {
    
    
    var receivedTicket : TicketBefore?
    let imageNames = ["spiderman", "Joker", "batman"]
    @IBOutlet weak var image: UIImageView!
    var qrImagei: UIImage!
    @IBOutlet weak var cardCnn: UITextField!
    @IBOutlet weak var cardMonth: UILabel!
    
    @IBOutlet weak var cardCvv: UILabel!
    @IBOutlet weak var ödenecekUcret: UILabel!
    @IBOutlet weak var monthDate: UITextField!
    @IBOutlet weak var yearDate: UITextField!
    
    @IBOutlet weak var cardyılı: UILabel!
    @IBOutlet weak var cardNu: UILabel!
    @IBOutlet weak var cardSahibi: UILabel!
    @IBOutlet weak var cardNo: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardSahibiName: UITextField!
    @IBOutlet weak var fillmNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seatCodeLabel: UILabel!
    @IBOutlet weak var saloNo: UILabel!
    @IBOutlet weak var ödenecekMaliyet: UILabel!
    
    @IBOutlet weak var ödemeBTN: UIButton!
    
    var paymentInfo = PaymentInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        //modalPresentationStyle = .overFullScreen
        print("paymentdayız")
       // cardSahibi.text = "Card Sahibi"
       
        
        cardNo.delegate = self
        cardCnn.delegate = self
        yearDate.delegate = self
        monthDate.delegate = self
        yearDate.placeholder = "YY"
        monthDate.placeholder = "MM"
        cardSahibiName.delegate = self
        cardNo.placeholder = "Kart Numarası"
        cardCnn.delegate = self
        cardCnn.placeholder = "CVV"
       
        cardSahibiName.delegate = self
        cardSahibiName.placeholder = "Kart Sahibinin Adı"
        image.image = UIImage(named: imageNames[0])
        fillmNameLabel.text = receivedTicket?.eventName
        dateLabel.text = receivedTicket?.eventDate
        timeLabel.text = receivedTicket?.eventTime
        saloNo.text = "Salon-2"
        seatCodeLabel.text = receivedTicket!.seat.seatCode
        if let eventPrice = receivedTicket?.eventPrice {
                    ödenecekMaliyet.text = "\(eventPrice) TL" // Örneğin, "50 TL" şeklinde bir değer atıyoruz.
                }
        
        
        
        //print("receivedTicket:", receivedTicket)
        
      
        
        if let unwrappedTicket = receivedTicket {
            // receivedTicket bir Optional değilse ve değeri varsa, bu blok çalışır.
            paymentInfo.ticketInfo = unwrappedTicket
            
            
            print("paymentInfo::",paymentInfo.ticketInfo)

           //sendPaymentsInfo(paymentInfo: paymentInfo)

        } else {
            // receivedTicket değeri nil olduğunda burası çalışır.
            print("receivedTicket değeri nil.")
            // Opsiyonel değeri ele almak için burada gerekli diğer işlemleri yapabilirsiniz.
        }

        //paymentInfo.ticketInfo = receivedTicket

       // paymentInfo.ticketInfo.seat = receivedTicket.seat
        
       }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Kart Sahibinin Adı":
            paymentInfo.cardName = textField.text ?? "Büşra Ece OK"
            
            print("paymentInfo in textField:",paymentInfo)
            
        case "Kart Numarası":
            paymentInfo.cardNo = textField.text ?? "4548 5460 7348 1125"
            
            
        case "MM":
            paymentInfo.cardMonth = textField.text ?? "10"
            
        case "CVV":
            paymentInfo.cardCnn = textField.text ?? "569"
            
            
        case "YY":
            paymentInfo.cardYear = textField.text ?? "25"
            
            
        
            
            
            
        default:
            break
        }
       
    }
    
    

    
    func sendPaymentsInfo(paymentInfo: PaymentInfo, completion: @escaping (UIImage?) -> Void) {
        
        var urlComponents = URLComponents(string: "http://localhost:8080/api/v1/tickets/payments")!
        
        
        // String'den Date nesnesine dönüşüm yapın
   
            
            // Query parametrelerini ekleyin
            urlComponents.queryItems = [
                URLQueryItem(name: "email", value: "mahmut.382@hotmail.com"),
                URLQueryItem(name: "cardNumber", value: paymentInfo.cardNo),  // Eğer dinamik bir tarih eklemek isterseniz burayı da değiştirebilirsiniz.
                URLQueryItem(name: "cardMonth", value: paymentInfo.cardMonth),
                URLQueryItem(name: "cardYear", value: paymentInfo.cardYear),
                URLQueryItem(name: "cardCvv", value: paymentInfo.cardCnn),
                URLQueryItem(name: "seatCode", value: paymentInfo.ticketInfo?.seat.seatCode),  // Eğer dinamik bir tarih eklemek isterseniz burayı da değiştirebilirsiniz.
               
                URLQueryItem(name: "eventCode", value: paymentInfo.ticketInfo?.eventCode),
                URLQueryItem(name: "eventDate", value: paymentInfo.ticketInfo?.eventDate ?? "24"),
                URLQueryItem(name: "eventTime", value: paymentInfo.ticketInfo?.eventTime)
                
            ]
            
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }
            
            // URLRequest oluşturun
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // URLSession ile isteği gerçekleştirin
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                print(data)
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Veri bir resim olarak işlenemedi.")
                    completion(nil)
                }
        }
       
            task.resume()
        }
        
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "QRsegue" {
               if let qrViewController = segue.destination as? QrTicketViewController {
                   qrViewController.generatedQRImage = self.qrImagei
               }
           }
       }
    

    @IBAction func ödemeTapped(_ sender: Any) {
       print("son hali",paymentInfo)
        sendPaymentsInfo(paymentInfo: paymentInfo) { [weak self] qrImage in
                DispatchQueue.main.async {
                    if let image = qrImage {
                        self?.qrImagei = image
                        self?.performSegue(withIdentifier: "QRsegue", sender: nil)
                    } else {
                        
                        // Hata durumu, kullanıcıya bilgi verebilirsiniz.
                        print("QR kodu oluşturulamadı veya bir hata oluştu.")
                    }
                }
            }
        
    } 
    
    

}
