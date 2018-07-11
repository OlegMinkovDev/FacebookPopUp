//
//  ViewController.swift
//  FacebookPopUp
//
//  Created by Oleg Minkov on 7/8/18.
//  Copyright © 2018 Oleg Minkov. All rights reserved.
//

import UIKit

enum Direction {
    case up
    case down
}

class ViewController: UIViewController {
    
    // MARK: - Variables
    var backgroundImageView: UIImageView = {
       
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "fb_core_data_bg")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var smileView: UIView = {
       
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.alpha = 0
        
        return view
    }()
    
    var stackView: UIStackView = {
       
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        view.addGestureRecognizer(longPress)
    }
    
    // MARK: - Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Configuration
    func setupViews() {
        
        view.addSubview(backgroundImageView)
        smileView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: smileView.leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: smileView.trailingAnchor, constant: -5).isActive = true
        stackView.topAnchor.constraint(equalTo: smileView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: smileView.bottomAnchor, constant: -5).isActive = true
        
        for view in getArrangedViews() {
            stackView.addArrangedSubview(view)
        }
    }
    
    // MARK: - Actions
    @objc func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        
        let touchLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            
            let correctX = UIScreen.main.bounds.width / 2 - Constant.smileViewWidth / 2
            smileView.frame = CGRect(x: correctX, y: touchLocation.y, width: Constant.smileViewWidth, height: Constant.smileViewHeight)
            smileView.transform = CGAffineTransform(translationX: 0, y: 0)
            view.addSubview(smileView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.smileView.alpha = 1
                self.smileView.transform = CGAffineTransform(translationX: 0, y: -100)
                
                self.calculateCurrentItem(locationX: touchLocation.x, locationY: touchLocation.y - 100)
                
            })
            
        } else if gesture.state == .changed {
          
            calculateCurrentItem(locationX: touchLocation.x, locationY: touchLocation.y - 100)
            
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.smileView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.smileView.alpha = 0
                
            }) { (complate) in
                self.smileView.removeFromSuperview()
            }
            
        }
    }
    
    // MARK: - Private methods
    fileprivate func getArrangedViews() -> [UIView] {
        
        let view1 = UIImageView()
        view1.image = UIImage(named: "blue_like")
        
        let view2 = UIImageView()
        view2.image = UIImage(named: "red_heart")
        
        let view3 = UIImageView()
        view3.image = UIImage(named: "cry_laugh")
        
        let view4 = UIImageView()
        view4.image = UIImage(named: "cry")
        
        let view5 = UIImageView()
        view5.image = UIImage(named: "surprised")
        
        let view6 = UIImageView()
        view6.image = UIImage(named: "angry")
        
        return [view1, view2, view3, view4, view5, view6]
    }
    
    fileprivate func calculateCurrentItem(locationX: CGFloat, locationY: CGFloat) {
        
        let itemLenght = smileView.frame.size.width / CGFloat(stackView.arrangedSubviews.count)
        
        let xInRange = locationX - smileView.frame.origin.x
        var currentIndex = 0
        
        for index in 0 ..< stackView.arrangedSubviews.count {
            animateItem(for: index, direction: .down)
        }
        
        if locationX > smileView.frame.origin.x && locationX < smileView.frame.origin.x + smileView.frame.size.width { currentIndex = Int(xInRange / itemLenght) }
        else { currentIndex = 0 }
        
        animateItem(for: currentIndex, direction: .up)
    }
    
    fileprivate func animateItem(for index: Int, direction: Direction) {
        
        let currentView = stackView.arrangedSubviews[index]
        
        var calculateY:CGFloat = 0
        if direction == .up { calculateY = Constant.pictureOffset }
        else { calculateY = 0 }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            currentView.transform = CGAffineTransform(translationX: 0, y: calculateY)
        })
    }
}
