class CreditToModel{
  String account;
  String bank;
  String currency;

  CreditToModel(this.account, this.bank, this.currency);

  Map<String, dynamic> toJson() => {
    'account': account,
    'bank': bank,
    'currency': currency,
  };

}