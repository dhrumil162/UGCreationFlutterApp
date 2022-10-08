class BusinessCards {
  late String cardName;
  late String filePath;
  List<BusinessCards> cards = List<BusinessCards>.empty(growable: true);
  BusinessCards(this.cardName, this.filePath);
}
