//
//  SeatsViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit


class SeatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var salonAdı: UILabel!
    @IBOutlet weak var seatsView: UICollectionView!
    @IBOutlet weak var devamBtn: UIButton!
    var selectedTickets : TicketBefore!
    
    
    @IBOutlet weak var image: UIImageView!
    var seatsInfo: [Seat] = []
   
    override func viewDidLoad() {
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            super.viewDidLoad()
            print("Fonksiyon 5 saniye sonra çalıştı!")
        }*/
        
        
        //self.seatsView.reloadData()
                        
        //sleep(5)
        image.image = UIImage(named: "Rectangle 25 (2)")
        print("seat")
        print(seatsInfo)
        salonAdı.text = "Salon-2"
        seatsView.delegate = self
        seatsView.dataSource = self
        devamBtn.isEnabled = false
        //image.image = UIImage(named: "Rectangle 25 (2)")
        
        if let layout = seatsView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (seatsView.bounds.width ) / 4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 2
            }
        print("selectedTicket")
        print(selectedTickets)
    }
    @IBAction func devamTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "paymentSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seatsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath)
        
        let currentSeat = seatsInfo[indexPath.item]
        
        // Hücrenin arkaplan rengini ve tıklanabilirliğini belirleme
        cell.backgroundColor = currentSeat.status == "RESERVED" ? UIColor.blue : UIColor.white
        cell.layer.cornerRadius = 8.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.isUserInteractionEnabled = currentSeat.status == "AVAILABLE" ? true : false
        
        if let label = cell.contentView.viewWithTag(105) as? UILabel {
            label.text = currentSeat.seatCode
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("seatsInfo")
        print(seatsInfo)
        var selectedSeat = seatsInfo[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)

            // Eğer seçili koltuğun durumu "false" ise (yani seçilebilir durumdaysa)
            if selectedSeat.status == "RESERVED" {
                
                // Seçili koltuğun arkaplan rengini kontrol edin
                if cell?.backgroundColor == UIColor.green {
                    // Eğer yeşil ise, seçimi geri alın (koltuğu beyaz yapın ve devam butonunu devre dışı bırakın)
                    selectedSeat.status = "AVAILABLE"
                    cell?.backgroundColor = UIColor.white
                    devamBtn.isEnabled = false
                } else {
                    // Eğer koltuk seçili değilse, seçimi yapın (koltuğu yeşil yapın ve devam butonunu etkinleştirin)
                    
                    cell?.backgroundColor = UIColor.green
                    devamBtn.isEnabled = true
                }
                //selectedTickets.seat = selectedSeat
            } else {
                selectedSeat.status = "RESERVED"
                // Eğer koltuk seçili değilse, seçimi yapın (koltuğu yeşil yapın ve devam butonunu etkinleştirin)
                selectedTickets.seat = selectedSeat
                cell?.backgroundColor = UIColor.green
                devamBtn.isEnabled = true
            }
        
        print("seat güncellendi")
        print(selectedTickets)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "paymentSegue" {
                if let paymentVC = segue.destination as? PaymentViewController {
                    paymentVC.receivedTicket = selectedTickets
                }
            }
        }

}
