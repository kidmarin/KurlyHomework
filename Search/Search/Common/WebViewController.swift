import SnapKit
import UIKit
import WebKit

final class WebViewController: UIViewController {

    private let url: URL

    // MARK: - UI

    private let webView = WKWebView()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        webView.load(URLRequest(url: url))
    }
}

// MARK: - Private
extension WebViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "닫기",
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
    }

    private func setupLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
