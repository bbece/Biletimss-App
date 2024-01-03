import UIKit

class FilmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var details : [Any] = []
    var areasDetails : [Any] = []
    let imageNames = ["spiderman", "Joker", "batman"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ENTERED")
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath)
        let movie = movies[indexPath.row]
        if let label = cell.contentView.viewWithTag(5) as? UILabel {
                label.text = movie.eventName
            }
        let imageName = imageNames[indexPath.row % imageNames.count] // Mod işlemi ile döngü yapar şekilde sırayla resimleri alıyoruz.
            
            // Set the image for the UIImageView with tag 4 in the cell
            if let imageView = cell.contentView.viewWithTag(4) as? UIImageView {
                imageView.image = UIImage(named: imageName)
            }

        
        // Assuming you might want to set movie image as well (assuming it's part of MovieInfo)
        // cell.filmImage.image = UIImage(named: movie.imageName)
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        //let areas = areas[indexPath.row]
        details.append(movie.eventName)
        
        details.append(movie.eventDescription)
        
        details.append(movie.eventDate)
       
        details.append(movie.eventTime)
        details.append(movie.eventPrice)
       
        details.append(movie.eventCode)
        
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // OK simgesinin rengini veya boyutunu değiştirin
            cell.backgroundColor = .orange // Örnek olarak rengi turuncu yapabiliriz.
            // Diğer özellikleri değiştirebilirsiniz.
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // OK simgesinin orijinal rengine veya boyutuna dönmesini sağlayın
            cell.backgroundColor = .white // Örnek olarak rengi siyah yapabiliriz.
            // Diğer özellikleri değiştirebilirsiniz.
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! FilmDetailsViewController
        
        info.myString = details
    }
    
    
    @IBOutlet weak var filmsView: UITableView!
    
    var movies: [MovieInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        filmsView.delegate = self
        filmsView.dataSource = self
        fetchMovies()
    }
    
    func fetchMovies() {
        guard let url = URL(string: "http://localhost:8080/api/v1/events?category=Sinema") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching movies:", error)
                return
            }
            
            guard let data = data else {
                print("Data not available")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.movies = try decoder.decode([MovieInfo].self, from: data)
                //self.areas = try decoder.decode([AreasInfo].self, from: data)
                
           
                DispatchQueue.main.async {
                    self.filmsView.reloadData()
                }
                
                
            } catch {
                print("Error decoding movies:", error)
            }
        }
        
        task.resume()
    }
    
   
}
