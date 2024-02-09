class OrderModel{
  double amount;
  String currency;

  OrderModel(this.amount, this.currency);

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
  };

}