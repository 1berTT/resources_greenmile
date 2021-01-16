import 'package:desafio_gm/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


/*void main(){
  testWidgets("Load more data", (WidgetTester tester)async{
    await tester.pumpWidget(HomePage());

    expect(find.byKey(ValueKey("loadMoreData")), findsOneWidget);

    print("Entrei aqui...");
    final loadMoreData = find.byKey(ValueKey("loadMoreData"));
    print("Sai aqui...");
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    await tester.tap(loadMoreData);
    await tester.pump(Duration(seconds: 45));

    expect(find.text("Value: Lade Daten..."), findsWidgets);
  });
}*/

/*void main(){
  group("Home page test", (){

    /*testWidgets("Home page - title", (tester) async{
      await tester.pumpWidget(MaterialApp(
        home: HomePage(),
      ));
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
    });*/

    testWidgets("Home page click buttom", (tester) async{
      await tester.pumpWidget(MaterialApp(
        home: HomePage(),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

    });

  });
}*/

