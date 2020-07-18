class Report {
  String symbol;
  String earningPerShare;
  String previousQuarter;
  String currentQuarter;
  String previousYear;
  Report.fromJSON(Map json)
      : symbol = json['symbol'],
        earningPerShare = json['earning_per_share'],
        previousQuarter = json['previous_quarter'],
        currentQuarter = json['current_quarter'],
        previousYear = json['previous_year'];
}
