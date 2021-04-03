class QuotationModel {
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  QuotationModel(this.quantity, this.unitPrice, this.totalPrice);

  QuotationModel.copy(QuotationModel other)
      : this.quantity = other.quantity,
        this.unitPrice = other.unitPrice,
        this.totalPrice = other.totalPrice;
}
