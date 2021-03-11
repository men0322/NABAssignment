//
//  HNWeatherTableViewCell.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 3/10/21.
//

import UIKit
import HNDesignSystem
import RxDataSources
import HNService

struct HNHomeWeatherCellViewModel: Equatable {
    let dateFormated: String?
    let pressure: String?
    let humidity: String?
    let average: String?
    let description: String?
    
    init(forecast: HNForecast) {
        dateFormated = forecast.date?.forecastDateFormated()
        pressure = String(format: "%.0f", forecast.pressure ?? 0.0)
        humidity = String(format: "%.0f", forecast.humidity ?? 0.0) + "%"
        description = forecast.descriptionFormated
        average = String(format: "%.0f°C", forecast.averageTempareture ?? 0.0)
    }
}

class HNWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTitleLabel: DSLabel!
    @IBOutlet weak var dateValueLabel: DSLabel!
    
    @IBOutlet weak var averageTemperatureTitleLabel: DSLabel!
    @IBOutlet weak var averageTemperatureValueLabel: DSLabel!
    
    @IBOutlet weak var pressureTitleLabel: DSLabel!
    @IBOutlet weak var pressureValueLabel: DSLabel!
    
    @IBOutlet weak var humidityTitleLabel: DSLabel!
    @IBOutlet weak var himidityValueLabel: DSLabel!
    
    @IBOutlet weak var descriptionTitleLabel: DSLabel!
    @IBOutlet weak var descriptionValueLabel: DSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configureUI() {
        dateTitleLabel.setStyle(DS.T16M(color: Colors.ink500))
        dateValueLabel.setStyle(DS.T16R(color: Colors.ink400))
        
        averageTemperatureTitleLabel.setStyle(DS.T16M(color: Colors.ink500))
        averageTemperatureValueLabel.setStyle(DS.T16R(color: Colors.red500))
        
        pressureTitleLabel.setStyle(DS.T16M(color: Colors.ink500))
        pressureValueLabel.setStyle(DS.T16R(color: Colors.red500))
        
        humidityTitleLabel.setStyle(DS.T16M(color: Colors.ink500))
        himidityValueLabel.setStyle(DS.T16R(color: Colors.red500))
        
        descriptionTitleLabel.setStyle(DS.T16M(color: Colors.ink500))
        descriptionValueLabel.setStyle(DS.T16R(color: Colors.red500))
    }
    
    var model: HNHomeWeatherCellViewModel? {
        didSet {
            dateTitleLabel.text = R.string.localizable.homeForecastDateTitle()
            averageTemperatureTitleLabel.text = R.string.localizable.homeForecastAverageTemperatureTitle()
            pressureTitleLabel.text = R.string.localizable.homeForecastPressureTitle()
            humidityTitleLabel.text = R.string.localizable.homeForecastHumidityTitle()
            descriptionTitleLabel.text = R.string.localizable.homeForecastDescriptionTitle()
            
            dateValueLabel.text = model?.dateFormated
            averageTemperatureValueLabel.text = model?.average
            pressureValueLabel.text = model?.pressure
            himidityValueLabel.text = model?.humidity
            descriptionValueLabel.text = model?.description
        }
    }
    
}
