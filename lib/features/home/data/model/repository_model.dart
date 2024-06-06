class Repository {
  final String name;
  final String description;
  final String ownerUsername;
  final String ownerHtmlUrl;
  final String htmlUrl;
  final bool fork;

  Repository({
    required this.name,
    required this.description,
    required this.ownerUsername,
    required this.ownerHtmlUrl,
    required this.htmlUrl,
    required this.fork,
  });
  @override
  String toString() {
    return 'Repository{name: $name, description: $description, ownerUsername: $ownerUsername, ownerHtmlUrl: $ownerHtmlUrl, htmlUrl: $htmlUrl, fork: $fork}';
  }

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? '',
      ownerUsername: json['owner']['login'],
      ownerHtmlUrl: json['owner']['html_url'],
      htmlUrl: json['html_url'],
      fork: json['fork'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'owner': {
        'login': ownerUsername,
        'html_url': ownerHtmlUrl,
      },
      'html_url': htmlUrl,
      'fork': fork,
    };
  }
}
