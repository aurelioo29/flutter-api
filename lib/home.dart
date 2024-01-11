import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listdata = [];
  List _searchResult = [];
  bool _isloading = true;
  TextEditingController _searchController = TextEditingController();

  Future _getdata(String search) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.6/flutter-api/db.php?search=$search'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _searchResult = _listdata;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _filterSearchResults(String query) {
    _getdata(query);
  }

  void _showAllData() {
    _getdata(""); // Menampilkan semua data
    _searchController.clear(); // Mengosongkan kotak pencarian
  }

  @override
  void initState() {
    _getdata(""); // Menampilkan semua data saat halaman pertama kali dimuat
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest API with PHP Native'),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchStock(_searchController, _filterSearchResults),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAllData();
            },
            icon: Icon(Icons.refresh), // Menambahkan tombol refresh
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      _searchResult[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${_searchResult[index]['quantity']}'),
                        Text('Price: ${_searchResult[index]['price']}'),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

class SearchStock extends SearchDelegate<String> {
  TextEditingController searchController;
  Function(String) onSearch;

  SearchStock(this.searchController, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
