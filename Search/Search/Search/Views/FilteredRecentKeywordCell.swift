import SnapKit
import UIKit

final class FilteredRecentKeywordCell: UITableViewCell {

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with keyword: RecentKeyword) {
        keywordLabel.text = keyword.keyword
        dateLabel.text = Const.dateFormatter.string(from: keyword.date)
    }
}

// MARK: - Private
extension FilteredRecentKeywordCell {

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(keywordLabel)
        contentView.addSubview(dateLabel)
    }

    private func setupLayout() {
        keywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
        }

        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Const
extension FilteredRecentKeywordCell {

    enum Const {

        static let identifier = "FilteredRecentKeywordCell"
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM. dd."
            return formatter
        }()
    }
}
