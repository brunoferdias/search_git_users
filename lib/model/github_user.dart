class GithubUser {
  final String login;
  final String avatarUrl;

  GithubUser(this.login, this.avatarUrl);

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      json['login'],
      json['avatar_url'],
    );
  }
}
