class BankTransferInfo {
  // String iss;
  // int sub;
 // int iat;
  //int exp;
  String orderId;
  int userId;
  int paymentId;
  num price;
  String accountNumber;
  String ciNumber;
  String accountType;
  String ownerName;
  String email;
  String bankName;

  BankTransferInfo({
    // required this.iss,
    // required this.sub,
   // required this.iat,
   // required this.exp,
    required this.orderId,
    required this.userId,
    required this.paymentId,
    required this.price,
    required this.accountNumber,
    required this.ciNumber,
    required this.accountType,
    required this.ownerName,
    required this.email,
    required this.bankName,
  });

  factory BankTransferInfo.fromJson(Map<String, dynamic> json) {
    return BankTransferInfo(
      // iss: json['iss'],
      // sub: json['sub'],
     // iat: json['iat']!=null?json['iat']:0,
      //exp: json['exp'],
      orderId: json['order_id'].toString(),
      userId: json['user_id'],
      paymentId: json['payment_id'],
      price: json['price'].toDouble(),
      accountNumber: json['account_number'],
      ciNumber: json['ci_number'],
      accountType: json['account_type'],
      ownerName: json['owner_name'],
      email: json['email'],
      bankName: json['bank_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'iss': iss,
      // 'sub': sub,
      //'iat': iat,
      //'exp': exp,
      'order_id': orderId,
      'user_id': userId,
      'payment_id': paymentId,
      'price': price,
      'account_number': accountNumber,
      'ci_number': ciNumber,
      'account_type': accountType,
      'owner_name': ownerName,
      'email': email,
      'bank_name': bankName,
    };
  }
}
