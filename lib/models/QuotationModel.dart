class QuotationModel {
  final int quantityValue;
  final double unitPriceValue;
  final double totalPriceValue;

  QuotationModel(this.quantityValue, this.unitPriceValue, this.totalPriceValue);

  QuotationModel.copy(QuotationModel other)
      : this.quantityValue = other.quantityValue,
        this.unitPriceValue = other.unitPriceValue,
        this.totalPriceValue = other.totalPriceValue;
}
