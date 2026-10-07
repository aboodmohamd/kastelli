import 'package:kastelli/core/helpers/validators.dart';
import 'package:kastelli/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('accepts a valid email and rejects an invalid one', () {
      expect(Validators.isEmail('abed@gmail.com'), isTrue);
      expect(Validators.isEmail('abed@gmail'), isFalse);
      expect(Validators.isEmail('abed'), isFalse);
    });

    test('accepts a phone number with 9 or 10 digits only', () {
      expect(Validators.isPhone('599123456'), isTrue);
      expect(Validators.isPhone('0599123456'), isTrue);
      expect(Validators.isPhone('12345'), isFalse);
      expect(Validators.isPhone('05991234ab'), isFalse);
    });

    test('requires a name of at least 2 characters', () {
      expect(Validators.isName('Ab'), isTrue);
      expect(Validators.isName('A'), isFalse);
      expect(Validators.isName('  '), isFalse);
    });
  });

  group('CartItemModel', () {
    test('total equals price multiplied by quantity', () {
      final item = CartItemModel(
        productId: '1',
        name: 'Dress',
        currency: 'SAR',
        optionId: '10',
        quantity: 3,
        price: 399,
        image: '',
        size: 'M',
      );

      expect(item.total, 1197);
    });
  });
}
