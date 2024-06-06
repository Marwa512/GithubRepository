
  import 'package:flutter/material.dart';

import 'launch_url.dart';

void showOptionsDialog({required BuildContext context , required String htmlUrl, required String ownerHtmlUrl } ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                launchURL(htmlUrl);
              },
              child: const Text('Go to Repository'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                launchURL(ownerHtmlUrl );
              },
              child: const Text('Go to Owner'),
            ),
          ],
        );
      },
    );
  }
