class QuotationsModel {
  final String project;
  final String timestamp;
  final String location;

  QuotationsModel(this.project, this.timestamp, this.location);

  QuotationsModel.copy(QuotationsModel other)
      : this.project = other.project,
        this.timestamp = other.timestamp,
        this.location = other.location;
}
