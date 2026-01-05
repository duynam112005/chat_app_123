import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,),
      child: GestureDetector(onTap: onTap,child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          children: [
            Icon(Icons.person),

            const SizedBox(width: 8,),

            Text(text),
          ],
        ),
      )),
    );
  }
}
