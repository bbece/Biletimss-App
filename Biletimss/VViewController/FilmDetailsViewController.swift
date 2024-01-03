//
//  FilmDetailsViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit
var seatss : [Seat] = []
let semaphore = DispatchSemaphore(value: 0)

class FilmDetailsViewController: UIViewController {
    
    
    // 11%20Jan formatında bir tarih formatı
    let imageNames = ["spiderman", "Joker", "batman"]
    @IBOutlet weak var seansCollectionView: UICollectionView!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmName: UITextView!
    
    @IBOutlet weak var filmDesc: UITextView!
    var myString : [Any] = []
    
    var selectedTicket: TicketBefore!
    var mockSeat : Seat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockSeat = Seat(eventCode: " ", seatCode: " ", status: " ")
        
        filmName.text = myString[0] as! String
        filmDesc.text = myString[1] as! String
        seansCollectionView.dataSource = self
        seansCollectionView.delegate = self
        filmImage.image = UIImage(named: imageNames[0])
        
        // Do any additional setup after loading the view.
    }
    
    func fetchSeatsFromBackend(eventTime: String, eventCode: String, eventDate:String) {
        // Oluşturulacak URL'yi belirtin
        var urlComponents = URLComponents(string: "http://localhost:8080/api/v1/tickets/seats")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        
        // String'den Date nesnesine dönüşüm yapın
        if let date = dateFormatter.date(from: eventDate) {
            // Şimdi, bu Date nesnesini "dd%20MMM" formatında bir stringe dönüştürelim
            dateFormatter.dateFormat = "dd'%20'MMM"  // %20 ifadesini ekliyoruz.
            let formattedDateString = dateFormatter.string(from: date)  // yourDate, göndermek istediğiniz Date nesnesidir.
            
            // Şimdi dateString'i URLComponents'da kullanabilirsiniz:
            
            print(formattedDateString)
            
            // Query parametrelerini ekleyin
            urlComponents.queryItems = [
                URLQueryItem(name: "areaName", value: "Salon-2"),
                URLQueryItem(name: "eventDate", value: formattedDateString),  // Eğer dinamik bir tarih eklemek isterseniz burayı da değiştirebilirsiniz.
                URLQueryItem(name: "eventTime", value: eventTime),
                URLQueryItem(name: "eventCode", value: eventCode)
            ]
            
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }
            
            // URLRequest oluşturun
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // URLSession ile isteği gerçekleştirin
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Alınan veriyi decode edin
                do {
                    seatss = try JSONDecoder().decode([Seat].self, from: data)
                    print("dd")
                    print("seat\(seatss)")
                    // Dönen seat objesini diğer ViewController'a iletin
                    /*DispatchQueue.main.async {
                        
                        let seatsViewController = SeatsViewController()
                        seatsViewController.seatsInfo = seatss
                        self.navigationController?.pushViewController(seatsViewController, animated: true)
                        semaphore.signal()
                    }*/ semaphore.signal()
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
                
            }.resume()
        }
        
        
    }}


extension FilmDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let innerArray = myString[2] as? [String] {
            
            return innerArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = seansCollectionView.dequeueReusableCell(withReuseIdentifier: "seansCell", for: indexPath) as UICollectionViewCell
        
        if let innerArray = myString[3] as? [String], indexPath.item < innerArray.count {

            let btnMetin = innerArray[indexPath.row]
            if let button = cell.contentView.viewWithTag(100) as? UIButton {
                button.setTitle(btnMetin, for: .normal)
            }
            
        }
        if let innerArray = myString[2] as? [String], indexPath.item < innerArray.count {
            let lblMetin = innerArray[indexPath.row]
            if let label = cell.contentView.viewWithTag(101) as? UILabel {
                label.text = lblMetin
                
            }  }
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.orange.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let lblMetinArray = myString[2] as? [String], indexPath.item < lblMetinArray.count,
           let btnMetinArray = myString[3] as? [String], indexPath.item < btnMetinArray.count {
            
            let eventName = myString[0]
            let eventDate = lblMetinArray[indexPath.item]
            let eventTime = btnMetinArray[indexPath.item]
            let eventCode = myString[5]
            let eventPrice = myString[4]
            print("bb")
            print(seatss)
            
            DispatchQueue.main.async { [self] in
                
                fetchSeatsFromBackend( eventTime: eventTime, eventCode: eventCode as! String, eventDate: eventDate )
            }
            let cell = seansCollectionView.dequeueReusableCell(withReuseIdentifier: "seansCell", for: indexPath) as UICollectionViewCell
            
            selectedTicket = TicketBefore(eventCode: eventCode as! String, eventName: eventName as! String, eventDate: eventDate, eventTime: eventTime, eventPrice: eventPrice as! Int , seat: mockSeat)
            print("cc")
            print(seatss)
            
            // fetchSeatsFromBackend fonksiyonunu çağır
           /* let secondVC = self.storyboard?.instantiateViewController(identifier: "SeatsViewController") as! SeatsViewController
           
                    secondVC.seatsInfo = seatss
          
                    secondVC.selectedTicket = selectedTicket
                    navigationController?.pushViewController(secondVC, animated: true)*/
                
            }

            performSegue(withIdentifier: "segueSeatsCell", sender: nil)
        }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! SeatsViewController
        print("zaa")
        print(info)
        info.seatsInfo = seatss
        info.selectedTickets = selectedTicket
    }
        
    }  
    
    
    
    


