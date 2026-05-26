import SnapKit
import UIKit

final class RecentKeywordHeaderView: UITableViewHeaderFooterView {
    static let identifier = "RecentKeywordHeaderView"

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension RecentKeywordHeaderView {
    private func setupUI() {
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
