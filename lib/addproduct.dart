import 'package:clothingapp/addproductdetails.dart';
import 'package:flutter/material.dart';
class addproduct extends StatefulWidget {
  const addproduct({super.key});

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  Future<void> _refreshPage() async {
    // Just rebuild the page
    setState(() {});}
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Add Product', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: Colors.orange,
        ),
        body: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateProductPage()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.045),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                      child: Center(
                        child: const Text('Add Product',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
