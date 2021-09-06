import 'package:uuid/uuid.dart';
import '../base_view_model.dart';
import '../../../data/models/entities/cart.dart';

class CartViewModel extends BaseViewModel {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items => _items;

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // ... increase qty
      _items.update(productId, (item) {
        return Cart(
          id: item.id,
          title: item.title,
          quantity: item.quantity + 1,
          price: item.price,
        );
      });
    } else {
      // ... add new
      _items.putIfAbsent(productId, () {
        return Cart(
          id: Uuid().v1(),
          title: title,
          quantity: 1,
          price: price,
        );
      });
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void undoAddToCart(String productId) {
    if (_items.containsKey(productId)) {
      var item = _items[productId] as Cart;
      if (item.quantity > 1) {
        _items.update(productId, (item) {
          return Cart(
            id: item.id,
            title: item.title,
            quantity: item.quantity - 1,
            price: item.price,
          );
        });
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  int get itemCount {
    // ... Logic for counting cart items can be up to us
    // Currently only product count is returned, not quantity of all products
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }
}
