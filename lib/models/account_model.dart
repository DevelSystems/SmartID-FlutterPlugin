class AccountModel{
  String client;
  int? clientRefId;
  String clientRefIdStr;
  String email;
  String phoneNumber;
  String session;
  String accountNumber;
  String bank;

  AccountModel(this.client, this.clientRefId, this.clientRefIdStr, this.email,
      this.phoneNumber, this.session, this.accountNumber, this.bank);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'client': client,
      'clientRefIdStr': clientRefIdStr,
      'email': email,
      'phoneNumber': phoneNumber,
      'session': session,
      'accountNumber': accountNumber,
      'bank': bank,
    };

    if (clientRefId != null) {
      data['clientRefId'] = clientRefId;
    }

    return data;
  }

}