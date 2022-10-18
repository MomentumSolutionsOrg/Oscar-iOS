//
//  AboutUsViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 07/09/2021.
//

import WebKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    private let viewModel = AboutUsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        showLoadingView()
        webView.loadHTMLString("about_us_html".localized, baseURL: nil)
//        setupViewModel()
//        viewModel.fetchData()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension AboutUsViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.reloadHtml = { [weak self] html in
            guard let self = self else { return }
            self.showLoadingView()
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

extension AboutUsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissLoadingView()
    }
}
