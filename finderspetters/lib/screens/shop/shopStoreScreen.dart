import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/shop.dart';
import 'package:finderspetters/screens/shop/shopscreen.dart';
import 'package:finderspetters/screens/shop/showPreviewItem.dart';
import 'package:flutter/material.dart';

class ShopStoreScreen extends StatefulWidget {
  final String storeId;

  const ShopStoreScreen({super.key, required this.storeId});

  @override
  State<ShopStoreScreen> createState() => _ShopStoreScreenState();
}

class _ShopStoreScreenState extends State<ShopStoreScreen> {
  final List<Shop> _places = [];
  String query = '';
  List<String> storeItems = [];
  List<String> searchItems = [];
  List<String> searchProductImages = [];
  List<int> searchProductPrices = [];
  List<String> searchProductDescription = [];
  List<String> productImages = [];
  List<int> productPrices = [];
  List<String> productDescription = [];
  bool isLoading = true;
  void search(String value) {
    searchItems.clear;
    searchProductDescription.clear;
    searchProductImages.clear;
    searchProductPrices.clear;
    List<String> searchItemsQuery = [];
    List<String> searchProductDescriptionQuery = [];
    List<int> searchProductPricesQuery = [];
    List<String> searchProductImagesQUery = [];

    for (int i = 0; i < storeItems.length; i++) {
      if (storeItems[i].toLowerCase().contains(value.toLowerCase())) {
        searchItemsQuery.add(storeItems[i]);
        searchProductDescriptionQuery.add(productDescription[i]);
        searchProductImagesQUery.add(productImages[i]);
        searchProductPricesQuery.add(productPrices[i]);
      }
    }
    setState(() {
      searchItems = searchItemsQuery;
      searchProductDescription = searchProductDescriptionQuery;
      searchProductImages = searchProductImagesQUery;
      searchProductPrices = searchProductPricesQuery;
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Shops Directory')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == widget.storeId.replaceAll(RegExp(r'\s+'), '')) {
          final shopPlaces = Shop.fromJson(doc.data());
          _places.add(shopPlaces);
        }
      });
      storeItems = _places[0].products;
      productImages = _places[0].productImages;
      print(_places[0].productPrice);
      productPrices = _places[0].productPrice;
      productDescription = _places[0].productDescription;
      print(_places[0].logoUrl);
      print(widget.storeId.replaceAll(RegExp(r'\s+'), ''));
      setState(() {
        isLoading = false;
        searchItems = storeItems;
        searchProductImages = productImages;
        searchProductPrices = productPrices;
        searchProductDescription = productDescription;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ShopScreenWidget()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Shops",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
      ),
      body: (isLoading == true)
          ? CircularProgressIndicator()
          : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 160,
                  height: 130,
                  margin: EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: NetworkImage(_places[0].logoUrl),
                          fit: BoxFit.fill)),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      onSubmitted: search,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter your search query',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => search(query),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: searchItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: (index == 0 || index == 3)
                          ? const EdgeInsets.only(left: 12)
                          : (index == 2 || index == 5)
                              ? const EdgeInsets.only(right: 12)
                              : const EdgeInsets.symmetric(horizontal: 1),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => PreviewItemScreen(
                                        storeId: widget.storeId,
                                        itemName: searchItems[index],
                                        itemDescription:
                                            searchProductDescription[index],
                                        itemImage: searchProductImages[index],
                                        itemPrice: searchProductPrices[index],
                                        storeAddress: _places[0].address,
                                        storeName: _places[0].name,
                                      )));
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.network(
                                    searchProductImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  searchItems[index],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Price: \$${searchProductPrices[index]}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
    );
  }
}
