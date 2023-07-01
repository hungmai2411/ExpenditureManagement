import 'dart:convert';

class Summary {
  final firstBalance;
  final lastBalance;
  final spended;
  Summary({
    required this.firstBalance,
    required this.lastBalance,
    required this.spended,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstBalance': firstBalance,
      'lastBalance': lastBalance,
      'spended': spended,
    };
  }

  factory Summary.fromMap(Map<String, dynamic> map) {
    return Summary(
      firstBalance: map['firstBalance'] ?? 0,
      lastBalance: map['finalBalance'] ?? 0,
      spended: map['spended'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Summary.fromJson(String source) =>
      Summary.fromMap(json.decode(source) as Map<String, dynamic>);

  Summary copyWith({
    double? firstBalance,
    double? lastBalance,
    double? spended,
  }) {
    return Summary(
      firstBalance: firstBalance ?? this.firstBalance,
      lastBalance: lastBalance ?? this.lastBalance,
      spended: spended ?? this.spended,
    );
  }
}
