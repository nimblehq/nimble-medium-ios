//
//  FeedCommentRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 23/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelInput {

    func deleteComment()
}

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelOutput {

    var id: Int { get }
    var uiModel: Driver<ArticleCommentRow.UIModel?> { get }
    var didDeleteComment: Signal<Void> { get }
    var didFailToDeleteComment: Signal<Void> { get }
    var isLoading: Driver<Bool> { get }
}

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelProtocol: ObservableViewModel {

    var input: ArticleCommentRowViewModelInput { get }
    var output: ArticleCommentRowViewModelOutput { get }
}

struct ArticleCommentRowViewModelArgs {

    let slug: String
    let comment: ArticleComment
}

final class ArticleCommentRowViewModel: ObservableObject, ArticleCommentRowViewModelProtocol {

    @Injected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected var deleteArticleCommentUseCase: DeleteArticleCommentUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let deleteCommentTrigger = PublishRelay<Void>()
    private let slug: String

    var input: ArticleCommentRowViewModelInput { self }
    var output: ArticleCommentRowViewModelOutput { self }

    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleCommentRow.UIModel?>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @PublishRelayProperty var didDeleteComment: Signal<Void>
    @PublishRelayProperty var didFailToDeleteComment: Signal<Void>
    let id: Int

    init(args: ArticleCommentRowViewModelArgs) {
        let comment = args.comment
        id = comment.id
        slug = args.slug

        getCurrentSessionUseCase.execute()
            .subscribe(with: self) { owner, user in
                owner.$uiModel.accept(
                    .init(
                        commentBody: comment.body,
                        commentUpdatedAt: comment.updatedAt.format(with: .monthDayYear),
                        authorName: comment.author.username,
                        authorImage: try? comment.author.image?.asURL(),
                        isAuthor: user?.username == comment.author.username
                    )
                )
            }
            .disposed(by: disposeBag)

        deleteCommentTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.deleteCommentTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleCommentRowViewModel: ArticleCommentRowViewModelInput {

    func deleteComment() {
        deleteCommentTrigger.accept(())
    }
}

extension ArticleCommentRowViewModel: ArticleCommentRowViewModelOutput {}

// MARK: Private

extension ArticleCommentRowViewModel {

    private func deleteCommentTriggered(owner: ArticleCommentRowViewModel) -> Observable<Void> {
        owner.$isLoading.accept(true)
        return deleteArticleCommentUseCase
            .execute(articleSlug: slug, commentId: "\(id)")
            .do(
                onError: { _ in
                    owner.$isLoading.accept(false)
                    owner.$didFailToDeleteComment.accept(())
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didDeleteComment.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}

extension Array where Element == ArticleComment {

    func viewModels(slug: String) -> [ArticleCommentRowViewModelProtocol] {
        map {
            Resolver.resolve(
                ArticleCommentRowViewModelProtocol.self,
                args: ArticleCommentRowViewModelArgs(slug: slug, comment: $0)
            )
        }
    }
}
