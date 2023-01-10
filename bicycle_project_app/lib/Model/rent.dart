class Rent {
  static List rentCounts = [];

  final int? rid; //auto increment라서
  final String staionCode;
  final String rcount;
  final String rdate;

  Rent(
      {this.rid,
      required this.staionCode,
      required this.rcount,
      required this.rdate});

  // 생성자임
  // dart에서는 똑같은 생성자 만들 수 없다? 그래서 만든 거임
  // 뭐가 들어올지 몰라서 다이나믹
  Rent.fromMap(Map<String, dynamic> res)
      : rid = res['rid'],
        staionCode = res['staionCode'],
        rcount = res['rcount'],
        rdate = res['rdate'];

  // 뭐가 들어올지 몰라서 object
  Map<String, Object?> toMap() {
    return {
      'rid': rid,
      'staionCode': staionCode,
      'rcount': rcount,
      'rdate': rdate
    };
  }
} //END
