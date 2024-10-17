class PriceFormat {
  String? price;

  String moneyformat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\d'), '');
      value = value.replaceAll(RegExp(r'\b(?=(\d{3})+(?!\d))'), ',');
      return value;
    } else {
      return price;
    }
  }
}
