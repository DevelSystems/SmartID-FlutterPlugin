class DeviceModel{
  String smartId;
  String ipAddress;

  DeviceModel(this.smartId, this.ipAddress);

  Map<String, dynamic> toJson() => {
    'smartId': smartId,
    'ipAddress': ipAddress,
  };

}