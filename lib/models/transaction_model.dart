class TransactionModel{
  String category;
  String type;
  String description;
  String reference;
  String date;
  Map<String, String> details;

  TransactionModel(this.category, this.type, this.description, this.reference,
      this.date, this.details);

  Map<String, dynamic> toJson() => {
    'category': category,
    'type': type,
    'description': description,
    'reference': reference,
    'date': date,
    'details': details,
  };
}