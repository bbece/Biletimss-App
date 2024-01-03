//
//  LogInViewController.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var passw: UITextField!
    @IBOutlet weak var eMail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        // Do any additional setup after loading the view.
    }
    
    func fetchDataFromURL(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let urlString = "http://localhost:8080/api/v1/users/login"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let params: [String: Any] = [
                "email": email,
                "password": password
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                print("JSON dönüşüm hatası: \(error)")
                completion(false)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Hata : \(error)")
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                    completion(httpResponse.statusCode == 200)
                }
            }
            task.resume()
        }
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = eMail.text, let password = passw.text else {
            return
        }
        print("email")
        print(email)

        let urlString = "http://localhost:8080/api/v1/users/login" // Backend URL'sini buraya ekleyin
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let params: [String: Any] = [
                "email": email,
                "password": password
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                print("JSON dönüşüm hatası: \(error)")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Hata : \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    print(httpResponse)
                   
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            //UserDefaults.standard.set(email, forKey: "userEmail")
                            self.performSegue(withIdentifier: "filterSegue", sender: self)
                        }
                    }else {
                        self.showAlert(message: "Geçersiz kullanıcı adı veya şifre.")
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        }
    }
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                self.clearTextFields()
            })
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

        func clearTextFields() {
            eMail.text = ""
            passw.text = ""
        }
}
