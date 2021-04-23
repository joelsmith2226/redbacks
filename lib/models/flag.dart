class Flag {
  String message;
  int severity; // 0 -> transparent, 1 -> yellow, 2 -> red
  int percent;

  Flag(this.message, this.severity, this.percent);

  Flag.fromData(Map<String, dynamic> data) {
    this.message = data["message"];
    this.severity = data["severity"];
    this.percent = data["percent"];
  }

  Flag.empty () {
    this.message = '';
    this.severity = 0;
    this.percent = 100;
  }

  Map<String, dynamic> toMap(){
    return {
      "message" : this.message,
      "severity" : this.severity,
      "percent" : this.percent,
    };
  }

  String printStats() {
    return "$message - $percent% chance of playing";
  }

}