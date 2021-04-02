class QuotationsModel {
  final String subject;
  final String timestamp;
  final String location;

  QuotationsModel(this.subject, this.timestamp, this.location);

  QuotationsModel.copy(QuotationsModel other)
      : this.subject = other.subject,
        this.timestamp = other.timestamp,
        this.location = other.location;
}
