//
//  SearchSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit

class SearchSceneViewController: UIViewController {
    
    var timer = Timer()
    
    var searchText: String = ""
    
    var availableCities: [String] = [ "MANCHESTER CITY", "BRISTOL CITY", "BIRMINGHAM CITY", "NORWICH CITY", "CARDIFF CITY", "LEICESTER CITY", "SWANSEA CITY", "HULL CITY", "STOKE CITY" ]
   
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        return imageView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .black
        return button
    }()
    
    let availableCitiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AvailableCitiesTableViewCell.self, forCellReuseIdentifier: AvailableCitiesTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
        
    let inputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return textField
    }()
    
    
    let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let searchIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupKeyboardNotifications()
        setupTimer()
        setConstraints()
        availableCitiesTableView.reloadData()
    }
    
}

extension SearchSceneViewController {
    
    func setupViews() {
        
        view.addSubviews([backgroundImageView, cancelButton, availableCitiesTableView, inputField])
        
        searchIconView.addSubview(searchIcon)
        
        inputField.delegate = self
        inputField.leftViewMode = .always
        inputField.leftView = searchIconView
        
        availableCitiesTableView.dataSource = self
        availableCitiesTableView.delegate = self
    }
    
    func setupKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchCity), userInfo: nil, repeats: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        else { return }
        
        let newBottomOffset_inputField = view.frame.height - keyboardEndFrame.height - 45
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
    
        UIView.animate(
            withDuration: duration * 2,
            delay: TimeInterval(1),
            options: animationCurve,
            animations: { [unowned self] in
                
                self.setConstraints_inputField(for: newBottomOffset_inputField)
                self.inputField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        let newBottomOffset_inputField = view.frame.height/4
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { [unowned self] in
                
                self.setConstraints_inputField(for: newBottomOffset_inputField)
                self.inputField.layoutIfNeeded()
            },
            completion: nil
        )
        
    }
    
    @objc func searchCity() {
        
        if let validText = inputField.text,
           validText.isEmpty == false {
            
            searchText = validText
            
//           fetchDelegate?(searchText)
        }
    }
    
    func setConstraints() {
        
        setConstraints_backgroundImageView()
        setConstraints_cancelButton()
        setConstraints_availableCitiesTableView()
        setConstraints_searchIcon()
        setConstraints_searchIconView()
        setConstraints_inputField(for: 100)
    }
    
    func setConstraints_backgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setConstraints_cancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.trailing.equalTo(view).inset(UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5))
        }
    }
    
    func setConstraints_availableCitiesTableView() {
        
        availableCitiesTableView.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(200)
        }
    }
    
    func setConstraints_searchIcon() {
        
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalTo(searchIconView)
        }
    }
    
    func setConstraints_searchIconView() {
        searchIconView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
    }
    
    func setConstraints_inputField(for bottomOffset: CGFloat) {
        
        inputField.snp.remakeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: bottomOffset, right: 5))
        }
    }
}

extension SearchSceneViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputField.resignFirstResponder()
        return true
    }
}

extension SearchSceneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AvailableCitiesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: availableCities[indexPath.row])
        return cell
    }
    
    
    
}

extension SearchSceneViewController: UITableViewDelegate {
    
    
}


