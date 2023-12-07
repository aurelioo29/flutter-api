class Stock {
  final String id;
  final String name;
  final String quantity;
  final String price;

  Stock({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
      };

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        id: json['id'].toString(),
        name: json['name'].toString(),
        quantity: json['quantity'].toString(),
        price: json['price'].toString(),
      );
}
