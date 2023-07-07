import 'package:flutter/material.dart';
import 'package:koobits_flutter_app/core/model/post/post_data.dart';

class PostDataWidget extends StatelessWidget {
  final PostData postData;

  const PostDataWidget(this.postData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postData.title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(postData.body),
          ],
        ),
      ),
    );
  }
}
