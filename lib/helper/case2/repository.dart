import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  final String name;
  final String description;
  final int stars;
  final String ownerName;
  final String ownerAvatarUrl;

  Repository({
    required this.name,
    required this.description,
    required this.stars,
    required this.ownerName,
    required this.ownerAvatarUrl,
  });

  static Repository fromMap(Map<String, dynamic> map) {
    return Repository(
      name: map['name'],
      description: map['description'] ?? "There is no description" ,
      stars: map['id'],
      ownerName: map['full_name'],
      ownerAvatarUrl: map['owner']['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stars': stars,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
    };
  }

  static Future<List<Repository>> fetchRepositories() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> reposList = data['items'];
      final List<Repository> repositories = [];
      print(reposList.length);
      for (var repoData in reposList) {
        print('add status');
        final repo = Repository.fromMap(repoData);
        print('add success');
        repositories.add(repo);
      }
      print('return reached ');
      return repositories;
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}
