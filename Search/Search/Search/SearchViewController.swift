import RIBs
import RxSwift
import SnapKit
import UIKit

protocol SearchPresentableListener: AnyObject {
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?

    // MARK: - UI

    private let searchTextField: UITextField = {
        let textField = UITextField()
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        iconContainer.addSubview(iconView)
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        textField.placeholder = "저장소"
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()

    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
}

// MARK: - DataSource
extension SearchViewController {
    private nonisolated enum Section: Hashable, Sendable {
        case recentKeyword
        case filteredRecentKeyword
        case searchResult
    }

    private nonisolated enum Item: Hashable {
        case recentKeyword(String)
        case filteredRecentKeyword(String)
        case searchResult(String)
    }
}

// MARK: - Private
extension SearchViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(searchTextField)
        view.addSubview(resultTableView)
    }

    private func setupLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        resultTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        UITableViewDiffableDataSource(tableView: resultTableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            switch item {
            case .recentKeyword(let keyword),
                 .filteredRecentKeyword(let keyword):
                config.text = keyword
            case .searchResult(let result):
                config.text = result
            }
            cell.contentConfiguration = config
            return cell
        }
    }
}
