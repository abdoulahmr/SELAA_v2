class Order {
  String orderId;
  String userId;
  List<OrderItem> items;
  DateTime orderDate;
  double totalAmount;
  String status;

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
  });

  @override
  String toString() {
    return 'Order(orderId: $orderId, userId: $userId, items: $items, '
        'orderDate: $orderDate, totalAmount: $totalAmount, status: $status)';
  }
}

class OrderItem {
  String productId;
  String productName;
  int quantity;
  double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  String toString() {
    return 'OrderItem(productId: $productId, productName: $productName, '
        'quantity: $quantity, unitPrice: $unitPrice)';
  }
}
