class UseStatus {
  final String staLoc;
  final String rentNm;
  final String statData;
  final String rentCnt;
  final String rtnCnt;
  final int startIndex;
  final int endIndex;

  const UseStatus({
    required this.staLoc,
    required this.rentCnt,
    required this.statData,
    required this.rentNm,
    required this.rtnCnt,
    required this.startIndex,
    required this.endIndex,
  });

  factory UseStatus.fromJson(Map<String, dynamic> json) {
    return UseStatus(
      staLoc: json['STA_LOC'] as String,
      rentNm: json['RENT_NM'] as String,
      statData: json['STAT_DATA'] as String,
      rentCnt: json['RENT_CNT'] as String,
      rtnCnt: json['RTN_CNT'] as String,
      startIndex: json['START_INDEX'] as int,
      endIndex: json['END_INDEX'] as int,
    );
  }
}
