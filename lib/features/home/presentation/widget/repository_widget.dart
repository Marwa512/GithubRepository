import 'package:flutter/material.dart';
import '../../../../core/utils/function/show_dialog.dart';
import '../../data/model/repository_model.dart';

class RepositoryListItem extends StatelessWidget {
  final Repository repository;

  RepositoryListItem(this.repository);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: () => showOptionsDialog(context: context, htmlUrl: repository.htmlUrl, ownerHtmlUrl: repository.ownerHtmlUrl),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
            color: repository.fork ? Colors.white : Colors.lightGreen[100],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(repository.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(repository.description),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text("Owner: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(repository.ownerUsername),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
