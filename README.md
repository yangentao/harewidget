## HareWidget
A flutter widget that merge StatefulWidget & State into one widget.

## Usage
After property changed, we can invoke 'updateState()' to rebuild it.

```dart
import 'package:flutter/material.dart';
import 'package:harewidget/harewidget.dart';

void main() {
  HareTextWidget hareText = HareTextWidget("Hello");

  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hareText,
          TextButton(
            onPressed: () {
              // property changed
              hareText.text = "Clicked"; 
              // invoke updateState() to rebuild
              hareText.updateState();    
            },
            child: Text("Click"),
          ),
        ],
      ),
    ),
  );
}

class HareTextWidget extends HareWidget {
  String text;

  HareTextWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
```