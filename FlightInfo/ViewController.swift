//
//  ViewController.swift
//  FlightInfo
//
//  Created by Vladimir Gusev on 27.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bg-snowy")
        return imageView
    }()
    
    lazy var navBar = UIView()
    
    lazy var summaryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon-blue-arrow")
        return imageView
    }()
    
    lazy var summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.text = "Flight Summary"
        summaryLabel.font = .systemFont(ofSize: 18)
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryLabel.textColor = .white
        return summaryLabel
    }()
    
    lazy var plane: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "plane")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var statusBanner: UIImageView = {
        let imageView = UIImageView(image: .init(named: "banner"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var statusLabel = CustomLabel(text: "Status", color: .statusLabelColor, size: 29, alignment: .center)
    
    lazy var departureLabel = CustomLabel(text: "DEP", color: .goldLabelColor, size: 43)
    lazy var arriveLabel = CustomLabel(text: "ARR", color: .goldLabelColor, size: 43, alignment: .right)
    lazy var flightsNumberLabel = CustomLabel(text: "Fl. Nr.", color: .white, size: 27)
    lazy var gateNumberLabel = CustomLabel(text: "Gate nr.", color: .white, size: 27, alignment: .right)
    
    private let snowView = SnowView( frame: .init(x: -150, y:-100, width: 300, height: 50) )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutBackground()
        layoutNavBar()
        layoutLabels()
        
        layoutStatusLabel()
        layoutPlane()
        layoutDepartureLabel()
        layoutArriveLabel()
        
        setupNavBar()
        
        let snowClipView = UIView( frame: view.frame.offsetBy(dx: 0, dy: 50) )
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
        
        changeFlight(to: .londonToParis, animated: false)
    }
    
    
}

private extension ViewController {
    //MARK:- Animations
    
    func fade(to image: UIImage, showEffects: Bool) {
        // Create & setup temp view
        let tempView = UIImageView(frame: backgroundView.frame)
        tempView.image = image
        tempView.alpha = 0
        tempView.center.y += 20
        tempView.bounds.size.width = backgroundView.bounds.size.width * 1.3
        backgroundView.superview?.insertSubview(tempView, aboveSubview: backgroundView)
        
        UIView.animate(withDuration: 0.5) {
            // Fade temp view in
            tempView.alpha = 1
            tempView.center.y -= 20
            tempView.bounds.size = self.backgroundView.bounds.size
            self.snowView.isHidden = !showEffects
        } completion: { _ in
            // Update background image & remove tempView
            self.backgroundView.image = image
            tempView.removeFromSuperview()
        }
    }
    
    func move(label: UILabel, text: String, offset: CGPoint) {
        //TODO: Animate a label's translation property
    }
    
    func cubeTransition(label: UILabel, text: String) {
        //TODO: Create a faux rotating cube animation
    }
    
    func depart() {
        //TODO: Animate the plane taking off and landing
    }
    
    func changeSummary(to summaryText: String) {
        //TODO: Animate the summary text
    }
    
    func changeFlight(to flight: Flight, animated: Bool = false) {
        // populate the UI with the next flight's data
        departureLabel.text = flight.origin
        arriveLabel.text = flight.destination
        flightsNumberLabel.text = flight.number
        gateNumberLabel.text = flight.gateNumber
        statusLabel.text = flight.status
        summaryLabel.text = flight.summary
        
        if animated {
            // TODO: Call your animation
            fade(to: UIImage(named: flight.weatherImageName)!, showEffects: flight.showWeatherEffects)
        } else {
            backgroundView.image = UIImage(named: flight.weatherImageName)
        }
        
        // schedule next flight
        delay(seconds: 3) {
            self.changeFlight(
                to: flight.isTakingOff ? .parisToRome : .londonToParis,
                animated: true
            )
        }
    }
    
    //MARK:- utility methods
    func duplicate(_ label: UILabel) -> UILabel {
        let newLabel = UILabel(frame: label.frame)
        newLabel.font = label.font
        newLabel.textAlignment = label.textAlignment
        newLabel.textColor = label.textColor
        newLabel.backgroundColor = label.backgroundColor
        return newLabel
    }
}

private extension ViewController {
    func layoutBackground() {
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func layoutNavBar() {
        view.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
        ])
        
        layoutNavBarStackView()
    }
    
    func layoutNavBarStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            summaryIcon,
            summaryLabel
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isUserInteractionEnabled = true
        stackView.contentMode = .scaleToFill
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        navBar.addSubview(stackView)
        
        let stackViewCenterYConstraint = stackView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor)
        stackViewCenterYConstraint.priority = UILayoutPriority(750)
        
        let stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        stackViewTopConstraint.priority = UILayoutPriority(1000)
        
        NSLayoutConstraint.activate([
            stackViewCenterYConstraint,
            stackViewTopConstraint,
            stackView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    func layoutLabels() {
        layoutFlightLabel()
        layoutGateLabel()
    }
    
    func layoutFlightLabel() {
        let flightsLabel = CustomLabel(text: "Flight", color: .white, size: 19)
        
        view.addSubview(flightsLabel)
        
        let labelTopConstraint = flightsLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30)
        labelTopConstraint.priority = UILayoutPriority(750)
        
        let labelCenterXConstraint = NSLayoutConstraint(
            item: flightsLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: backgroundView,
            attribute: .centerX,
            multiplier: 0.3,
            constant: 0)
        
        labelCenterXConstraint.priority = UILayoutPriority(1000)
        
        let labelCenterYConstraint = NSLayoutConstraint(
            item: flightsLabel,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: backgroundView,
            attribute: .centerY,
            multiplier: 0.33,
            constant: 0)
        
        view.addSubview(flightsNumberLabel)
        
        NSLayoutConstraint.activate([
            labelTopConstraint,
            labelCenterXConstraint,
            labelCenterYConstraint,
            flightsLabel.heightAnchor.constraint(equalToConstant: 26),
            
            flightsNumberLabel.leadingAnchor.constraint(equalTo: flightsLabel.leadingAnchor),
            flightsNumberLabel.topAnchor.constraint(equalTo: flightsLabel.bottomAnchor, constant: 30),
            flightsNumberLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func layoutGateLabel() {
        let label = CustomLabel(text: "Gate", color: .white, size: 19, alignment: .right)
        
        view.addSubview(label)
        
        let labelTopConstraint = label.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30)
        labelTopConstraint.priority = UILayoutPriority(750)
        
        let labelCenterXConstraint = NSLayoutConstraint(
            item: label,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: backgroundView,
            attribute: .centerX,
            multiplier: 1.7,
            constant: 0)
        
        labelCenterXConstraint.priority = UILayoutPriority(1000)
        
        let labelCenterYConstraint = NSLayoutConstraint(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: backgroundView,
            attribute: .centerY,
            multiplier: 0.33,
            constant: 0)
        
        view.addSubview(gateNumberLabel)
        
        NSLayoutConstraint.activate([
            labelTopConstraint,
            labelCenterXConstraint,
            labelCenterYConstraint,
            label.heightAnchor.constraint(equalToConstant: 26),
            
            gateNumberLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            gateNumberLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            gateNumberLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        
    }
    
    func layoutPlane() {
        view.addSubview(plane)
        
        NSLayoutConstraint.activate([
            plane.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            plane.centerXAnchor.constraint(equalTo: statusBanner.centerXAnchor),
            plane.bottomAnchor.constraint(equalTo: statusBanner.topAnchor, constant: -76)
        ])
    }
    
    func layoutDepartureLabel() {
        view.addSubview(departureLabel)
        
        NSLayoutConstraint.activate([
            departureLabel.leadingAnchor.constraint(equalTo: flightsNumberLabel.leadingAnchor),
            departureLabel.centerYAnchor.constraint(equalTo: plane.centerYAnchor),
            departureLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func layoutArriveLabel() {
        view.addSubview(arriveLabel)
        
        NSLayoutConstraint.activate([
            arriveLabel.trailingAnchor.constraint(equalTo: gateNumberLabel.trailingAnchor),
            arriveLabel.centerYAnchor.constraint(equalTo: plane.centerYAnchor),
            arriveLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func layoutStatusLabel() {
        view.addSubview(statusBanner)
        statusBanner.addSubview(statusLabel)
        
        let statusBannerYConstraint = NSLayoutConstraint(
            item: statusBanner,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: backgroundView,
            attribute: .centerY,
            multiplier: 1.6,
            constant: 0)
        
        NSLayoutConstraint.activate([
            statusBanner.widthAnchor.constraint(equalToConstant: 193),
            statusBanner.heightAnchor.constraint(equalToConstant: 47),
            statusBannerYConstraint,
            
            statusLabel.widthAnchor.constraint(equalTo: statusBanner.widthAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: statusBanner.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBanner.centerYAnchor, constant: -2)
        ])
    }
    
    
    func setupNavBar() {
        navBar.backgroundColor = .black
    }
}

private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
