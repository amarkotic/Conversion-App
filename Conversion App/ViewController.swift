//
//  ViewController.swift
//  Conversion App
//
//  Created by Antonio Markotic on 11/07/2019.
//  Copyright © 2019 Antonio Markotic. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let url = URL(string: "http://hnbex.eu/api/v1/rates/daily/?date=YYYY-MM-DD")
    var firstValue : String?
    var secondValue : String?
    var buyingRate: Double?
    var sellingRate: Double?
    var myCurrency = ["AUD", "CAD", "CZK", "DKK", "HUF", "JPY", "NOK", "SEK", "CHF", "GBP", "USD", "BAM", "EUR", "PLN"]
    var array:[AnyObject] = []
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    
//4 Funkcije za postavljanje UIPickerView-ova
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerView1{
            if row == 4 {
                let buyingRate1 = array[row]["buying_rate"]!
                buyingRate = Double("\(buyingRate1!)")!/100
                firstValue = myCurrency[row]
            }
            else if row == 5{
                let buyingRate1 = array[row]["buying_rate"]!
                buyingRate = Double("\(buyingRate1!)")!/100
                firstValue = myCurrency[row]
            }
            else {
                let buyingRate1 = array[row]["buying_rate"]!
                buyingRate = Double("\(buyingRate1!)")!
                firstValue = myCurrency[row]
            }
        }
        else if pickerView == pickerView2 {
            if row == 4 {
                let sellingRate1 = array[row]["selling_rate"]!
                sellingRate = Double("\(sellingRate1!)")!/100
                secondValue = myCurrency[row]
            }
            else if row == 5{
                let sellingRate1 = array[row]["selling_rate"]!
                sellingRate = Double("\(sellingRate1!)")!/100
                secondValue = myCurrency[row]
            }
            else {
                let sellingRate1 = array[row]["selling_rate"]!
                sellingRate = Double("\(sellingRate1!)")
                secondValue = myCurrency[row]
            }
        }
    }
    
//Funkcija koja se pokreće kada se učita zaslon aplikacije(u njoj je postavljena pozadinska slika, uređen "submit gumb" i prizvana funkcija parsing()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parsing()
        
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        
        let backgroundImage = UIImage.init(named: "96520416-white-abstract-simple-uptrend-financial-chart-background-")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = 0.6
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
//Funkcija parsing koja povlači sve podatke o valutama s linka i sprema ih u Array
    func parsing() {
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
            }else  {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.array = myJson as! [AnyObject]
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    

//Funkcija koja se pokreće pritiskom na Submit gumb
    @IBAction func submitButtonPressed(_ sender: Any) {
        let finalSellingRate = (sellingRate!)
        let finalBuyingRate = (buyingRate!)
        let result = String(format: "%.3f", (finalBuyingRate/finalSellingRate))
        resultLabel.text = "1 \(firstValue!) = \(result) \(secondValue!) "
    }
}
