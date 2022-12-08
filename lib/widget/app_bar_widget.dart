import 'package:flutter/material.dart';
import 'package:proto_bm2/model/app/singleton_model.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;

  const AppBarWidget({Key? key, required this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (subTitle != null) const SizedBox(height: 4),
          if (subTitle != null)
            Text(
              subTitle!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(
        MediaQuery.of(SingletonModel.shared.context!).size.width,
        kToolbarHeight,
      );
}
