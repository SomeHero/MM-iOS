//
//  TextEditorViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/29/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SlackTextViewController

protocol TextEditorDelegate: class {
    func didSubmitText(text: String)
}
class TextEditorViewController: UIViewController {
    private var text: String
    weak var textEditorDelegate: TextEditorDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let _scroll = UIScrollView()
        self.view.addSubview(_scroll)
        
        return _scroll
    }()
    private lazy var textView: UITextView = {
        let _textView = UITextView()
        
        self.scrollView.addSubview(_textView)
        return _textView
    }()
    init(title: String, text: String) {
        self.text = text
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = text
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(TextEditorViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(TextEditorViewController.saveClicked(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        textView.snp.updateConstraints { (make) in
            make.edges.equalTo(scrollView).inset(10)
            make.height.greaterThanOrEqualTo(400)
            make.width.equalTo(UIScreen.main.bounds.width-20)
        }
    }
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    func saveClicked(_ sender: UIButton) {
        textEditorDelegate?.didSubmitText(text: textView.text)
    }
}
