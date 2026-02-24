class Donation {
  final String id;
  final String name;
  final String location;
  final double amount;
  final DateTime date;
  final String? phone;
  final String? email;
  final String status;
  final String paymentMethod;
  final String purpose;

  Donation({
    required this.id,
    required this.name,
    required this.location,
    required this.amount,
    required this.date,
    this.phone,
    this.email,
    this.status = 'completed',
    this.paymentMethod = 'PhonePe',
    this.purpose = 'General',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'amount': amount,
      'date': date.toIso8601String(),
      'phone': phone,
      'email': email,
      'status': status,
      'paymentMethod': paymentMethod,
      'purpose': purpose,
    };
  }

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      phone: json['phone'],
      email: json['email'],
      status: json['status'] ?? 'completed',
      paymentMethod: json['paymentMethod'] ?? 'PhonePe',
      purpose: json['purpose'] ?? 'General',
    );
  }

  Donation copyWith({
    String? id,
    String? name,
    String? location,
    double? amount,
    DateTime? date,
    String? phone,
    String? email,
    String? status,
    String? paymentMethod,
    String? purpose,
  }) {
    return Donation(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      purpose: purpose ?? this.purpose,
    );
  }

  static const List<String> purposes = [
    'General',
    'Bhog (Food)',
    'Pandal Decoration',
    'Pratima (Idol)',
    'Cultural Programs',
  ];

  static const List<String> statuses = [
    'pending',
    'confirmed',
    'completed',
    'failed',
  ];
}
