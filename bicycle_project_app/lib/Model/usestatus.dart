class UseStatus {
  final String sta_loc;
  final String rent_nm;
  final String stat_data;
  final String rent_cnt;
  final String rtn_cnt;
  final int start_index;
  final int end_index;

  const UseStatus({
    required this.sta_loc,
    required this.rent_nm,
    required this.stat_data,
    required this.rent_cnt,
    required this.rtn_cnt,
    required this.start_index,
    required this.end_index,
  });

  factory UseStatus.fromJson(Map<String, dynamic> json) {
    return UseStatus(
      sta_loc: json['STA_LOC'] as String,
      rent_nm: json['RENT_NM'] as String,
      stat_data: json['STAT_DATA'] as String,
      rent_cnt: json['RENT_CNT'] as String,
      rtn_cnt: json['RTN_CNT'] as String,
      start_index: json['START_INDEX'] as int,
      end_index: json['END_INDEX'] as int,
    );
  }
}
