//
//  UserProfileViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 04/10/2021.
//

import Resolver
import RxCocoa
import RxSwift

protocol UserProfileViewModelInput {

    func getUserProfile()
    func toggleFollowUser()
}

protocol UserProfileViewModelOutput {

    var userProfileUIModel: Driver<UserProfileView.UIModel?> { get }
    var errorMessage: Signal<String> { get }
    var createdArticlesViewModel: Driver<UserProfileCreatedArticlesTabViewModelProtocol?> { get }
    var favouritedArticlesViewModel: Driver<UserProfileFavouritedArticlesTabViewModelProtocol?> { get }
    var didFailToToggleFollow: Signal<Void> { get }
}

protocol UserProfileViewModelProtocol: ObservableViewModel {

    var input: UserProfileViewModelInput { get }
    var output: UserProfileViewModelOutput { get }
}

final class UserProfileViewModel: ObservableObject, UserProfileViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let getCurrentUserTrigger = PublishRelay<Void>()
    private let getOtherUserProfileTrigger = PublishRelay<String>()
    private let toggleFollowUserTrigger = PublishRelay<Void>()
    private let username: String?

    var input: UserProfileViewModelInput { self }
    var output: UserProfileViewModelOutput { self }

    @PublishRelayProperty var didGetUserProfile: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @BehaviorRelayProperty(nil) var userProfileUIModel: Driver<UserProfileView.UIModel?>
    @BehaviorRelayProperty(nil) var createdArticlesViewModel: Driver<UserProfileCreatedArticlesTabViewModelProtocol?>
    // swiftlint:disable line_length
    @BehaviorRelayProperty(nil) var favouritedArticlesViewModel: Driver<UserProfileFavouritedArticlesTabViewModelProtocol?>
    @PublishRelayProperty var didFailToToggleFollow: Signal<Void>

    @Injected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    @Injected var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    @Injected var followUserUseCase: FollowUserUseCaseProtocol
    @Injected var unfollowUserUseCase: UnfollowUserUseCaseProtocol

    init(username: String? = nil) {
        self.username = username

        getCurrentUserTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)

        getOtherUserProfileTrigger
            .withUnretained(self)
            .flatMapLatest { owner, input in owner.getOtherUserProfileTriggered(owner: owner, username: input) }
            .subscribe()
            .disposed(by: disposeBag)

        toggleFollowUserTrigger
            .withUnretained(self)
            .filter { $0.0.username != nil }
            .flatMap { $0.0.toggleAuthorFollowing() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest {
                $0.0.toggleFollowUserTriggered(
                    owner: $0.0,
                    following: $0.1,
                    username: $0.0.username ?? ""
                )
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileViewModel: UserProfileViewModelInput {

    func getUserProfile() {
        if let username = username {
            getOtherUserProfileTrigger.accept(username)
        } else {
            getCurrentUserTrigger.accept(())
        }
    }

    func toggleFollowUser() {
        toggleFollowUserTrigger.accept(())
    }
}

extension UserProfileViewModel: UserProfileViewModelOutput {}

extension UserProfileViewModel {

    private func getCurrentUserTriggered(owner: UserProfileViewModel) -> Observable<Void> {
        getCurrentUserUseCase
            .execute()
            .do(
                onSuccess: {
                    owner.$userProfileUIModel.accept(owner.generateUIModel(fromUser: $0))
                    owner.$createdArticlesViewModel.accept(
                        Resolver.resolve(
                            UserProfileCreatedArticlesTabViewModelProtocol.self,
                            args: $0.username
                        )
                    )
                    owner.$favouritedArticlesViewModel.accept(
                        Resolver.resolve(
                            UserProfileFavouritedArticlesTabViewModelProtocol.self,
                            args: $0.username
                        )
                    )
                },
                onError: { error in
                    owner.$errorMessage.accept(error.detail)
                    owner.$userProfileUIModel.accept(nil)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func getOtherUserProfileTriggered(owner: UserProfileViewModel, username: String) -> Observable<Void> {
        getUserProfileUseCase
            .execute(username: username)
            .do(
                onSuccess: {
                    owner.$userProfileUIModel.accept(owner.generateUIModel(fromProfile: $0))
                },
                onError: { error in
                    owner.$errorMessage.accept(error.detail)
                    owner.$userProfileUIModel.accept(nil)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func generateUIModel(fromProfile profile: Profile) -> UserProfileView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !profile.username.isEmpty {
            username = profile.username
        }
        return UserProfileView.UIModel(
            avatarURL: try? profile.image?.asURL(),
            username: username,
            isFollowing: profile.following
        )
    }

    private func generateUIModel(fromUser user: User) -> UserProfileView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !user.username.isEmpty {
            username = user.username
        }
        return UserProfileView.UIModel(
            avatarURL: try? user.image?.asURL(),
            username: username,
            isFollowing: false
        )
    }

    private func toggleFollowUserTriggered(
        owner: UserProfileViewModel,
        following: Bool,
        username: String
    ) -> Observable<Void> {
        var completable: Completable?
        switch following {
        case true:
            completable = owner.followUserUseCase
                .execute(username: username)
        case false:
            completable = owner.unfollowUserUseCase
                .execute(username: username)
        }

        return completable?
            .do(
                onError: { _ in
                    owner.$didFailToToggleFollow.accept(())
                    owner.updateAuthorFollowing(!following)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(()) ?? .empty()
    }

    private func toggleAuthorFollowing() -> Observable<Bool> {
        guard let uiModel = $userProfileUIModel.value else { return .empty() }
        updateAuthorFollowing(!uiModel.isFollowing)

        return .just(!uiModel.isFollowing)
    }

    private func updateAuthorFollowing(_ value: Bool) {
        var uiModel = $userProfileUIModel.value
        uiModel?.isFollowing = value
        $userProfileUIModel.accept(uiModel)
    }
}
