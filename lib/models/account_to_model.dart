class AccountToModel{
  String client;
  int? clientRefId;
  String clientRefIdStr;
  String email;
  String phoneNumber;
  String session;
  String accountNumber;
  String bank;

  AccountToModel(this.client, this.clientRefId, this.clientRefIdStr, this.email,
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

    // Include clientRefId only if it's not null
    if (clientRefId != null) {
      data['clientRefId'] = clientRefId;
    }

    return data;
  }

}