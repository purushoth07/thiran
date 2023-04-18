import 'package:flutter/material.dart';
import 'package:thiran/common/common_widgets.dart';
import 'package:thiran/controllers/appload_controller.dart';
import 'package:thiran/helper/case2/repository.dart';
import 'package:thiran/helper/case2/repo_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class UseCase2 extends StatefulWidget {
  const UseCase2({Key? key}) : super(key: key);

  @override
  _UseCase2State createState() => _UseCase2State();
}

class _UseCase2State extends State<UseCase2> {
  final AppLoadController appLoadController =
  Get.put(AppLoadController.getInstance(), permanent: true);

  Future<List<Repository>>? _repositories;

  @override
  void initState() {
    super.initState();
    print('the length start of the repository');
    _repositories = DatabaseHelper.getRepositories().then((repositories) {
      print('the length of the repository');
      print(repositories.length);
      if (repositories.isEmpty) {
        return Repository.fetchRepositories().then((repositories) {
          print('the value of repositories');
          print(repositories.length);
          DatabaseHelper.saveRepositories(repositories);
          return repositories;
        });
      } else {
        return repositories;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appLoadController.themeColor,
        foregroundColor: Colors.black,
        title: heading(text: 'UseCase 2'),
      ),
      body: Center(
        child: FutureBuilder<List<Repository>>(
          future: _repositories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final repositories = snapshot.data!;
              return ListView.builder(
                itemCount: repositories.length,
                itemBuilder: (context, index) {
                  final repository = repositories[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      CachedNetworkImageProvider(repository.ownerAvatarUrl),
                    ),
                    title: Text(repository.name),
                    subtitle: Text(repository.description),
                    trailing: Text('${repository.stars} stars'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
