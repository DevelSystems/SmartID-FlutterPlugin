class DebitFromModel{
  String account;
  String bank;
  String currency;

  DebitFromModel(this.account, this.bank, this.currency);

  Map<String, dynamic> toJson() => {
    'account': account,
    'bank': bank,
    'currency': currency,
  };

}