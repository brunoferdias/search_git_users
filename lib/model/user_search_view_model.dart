import 'dart:async';
import 'package:fetch_git_users/repo/user_repo.dart';

import 'github_user.dart';

class UserSearchViewModel {
  final _usersController = StreamController<List<GithubUser>>();
  Stream<List<GithubUser>> get usersStream => _usersController.stream;
  final _repositoriesController = StreamController<List<dynamic>>();
  Stream<List<dynamic>> get repositoriesStream => _repositoriesController.stream;
  final _repository = UserRepository();

  void searchUsers(String query) {
    _repository.searchUsers(query).then((users) {
      _usersController.add(users);
    }).catchError((error) {
      _usersController.addError(error);
    });
  }

  void getUserRepositories(String username) {
    _repository.getUserRepositories(username).then((repositories) {
      _repositoriesController.add(repositories);
    }).catchError((error) {
      _repositoriesController.addError(error);
    });
  }

  void clearStreams() {
    _usersController.add([]);
    _repositoriesController.add([]);
  }

  void dispose() {
    _usersController.close();
    _repositoriesController.close();
  }
}
