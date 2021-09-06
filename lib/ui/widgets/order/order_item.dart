import 'package:flutter/material.dart';
import '../../../data/models/entities/cart.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/utilities/datetime_utils.dart';
import '../../../utils/extensions/app_extensions.dart';
import '../../../data/models/entities/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    List<Cart>? items = widget.order.cartItems;
    double baseHeight = 88;
    double expandedHeight = ((items?.length ?? 0) * 20.0 + 20);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? (expandedHeight + baseHeight) : baseHeight,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            _buildOrderWidget(),
            _buildOrderExpandedWidget(items, expandedHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderWidget() {
    return InkWell(
      onTap: _toggleExpandCollapse,
      borderRadius: BorderRadius.circular(2),
      child: ListTile(
        title: Text(
          '\$${widget.order.amount.format()}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
            '${DateTimeUtils.format(AppConstants.day_format, widget.order.date)}'
            ' @ '
            '${DateTimeUtils.format(AppConstants.time_format, widget.order.date)}'),
        trailing: Icon(
          _expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
        ),
      ),
    );
  }

  Widget _buildOrderExpandedWidget(List<Cart>? items, double expandedHeight) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: _expanded ? expandedHeight : 0,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          final item = items?.elementAt(index);
          return _buildOrderItemsWidget(item);
        },
        itemCount: items?.length ?? 0,
      ),
    );
  }

  Widget _buildOrderItemsWidget(Cart? item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item?.title ?? ''),
          Text(
            '${item?.quantity ?? 0}x \$${item?.price.format()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpandCollapse() {
    setState(() {
      _expanded = !_expanded;
    });
  }
}
