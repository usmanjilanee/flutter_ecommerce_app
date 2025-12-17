import 'package:flutter/material.dart';
import 'customer_page.dart';
class orderplace extends StatefulWidget {
  final double total;
  final List<dynamic> crt ;
  const orderplace({required this.total,required this.crt,super.key});

  @override
  State<orderplace> createState() => _orderplaceState(total: total,crt: crt);
}

class _orderplaceState extends State<orderplace> {
  final double total;
  final List<dynamic> crt ;
  _orderplaceState({required this.total,required this.crt}){}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Order Placed Successfully'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: crt.length,
                          itemBuilder: (context,index){
                            return Row(children: [
                              Text("${crt[index]["productData"]["title"].toString()}"),
                              Spacer(),
                              Text("${crt[index]["quantity"].toString()}")
                            ]
                            );
                          }),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total : ${total}"),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>GlassBottomNavExample()));
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4.0),
                        child: Text("Go To Home")),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}
