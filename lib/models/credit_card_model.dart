class CreditCardModel{
  String bin;
  String hash;
  String last4Digits;
  String token;

  CreditCardModel(this.bin, this.hash, this.last4Digits, this.token);

  Map<String, dynamic> toJson() => {
    'bin': bin,
    'hash': hash,
    'last4Digits': last4Digits,
    'token': token,
  };

}