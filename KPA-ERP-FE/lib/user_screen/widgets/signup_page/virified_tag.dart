import 'package:flutter/material.dart';

class VirifiedTag extends StatefulWidget {
  const VirifiedTag({
    Key? key,
  }) : super(key: key);

  @override
  _VirifiedTag createState() => _VirifiedTag();
}

class _VirifiedTag extends State<VirifiedTag> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/verified.png',
                width: 14.0,
                height: 14.0,
              ),
              const SizedBox(width: 5.0),
              const Text(
                'Verified',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
