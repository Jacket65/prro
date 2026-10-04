import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/bean.dart';

void main() {
  group('Bean.fromJson', () {
    test('parses id and name', () {
      final bean = Bean.fromJson(const {'id': 7, 'name': 'Арабіка'});
      expect(bean.id, 7);
      expect(bean.name, 'Арабіка');
    });

    test('parses a numeric-string id', () {
      expect(Bean.fromJson(const {'id': '12', 'name': 'x'}).id, 12);
    });

    test('falls back to id 0 and an empty name when keys are missing', () {
      final bean = Bean.fromJson(const {});
      expect(bean.id, 0);
      expect(bean.name, isEmpty);
    });
  });

  group('BeanGroup.fromJson', () {
    test('parses nested beans in wire order', () {
      final group = BeanGroup.fromJson(const {
        'id': 3,
        'name': 'Арабіка',
        'beans': [
          {'id': 1, 'name': 'Колумбія'},
          {'id': 2, 'name': 'Ефіопія'},
        ],
      });
      expect(group.id, 3);
      expect(group.name, 'Арабіка');
      expect(group.beans.map((b) => b.name), ['Колумбія', 'Ефіопія']);
    });

    test('defaults to no beans when the key is absent or null', () {
      expect(BeanGroup.fromJson(const {'id': 1, 'name': 'x'}).beans, isEmpty);
      expect(
        BeanGroup.fromJson(const {'id': 1, 'name': 'x', 'beans': null}).beans,
        isEmpty,
      );
    });
  });

  group('equality', () {
    test('two beans from the same payload are equal', () {
      expect(
        Bean.fromJson(const {'id': 7, 'name': 'Арабіка'}),
        Bean.fromJson(const {'id': 7, 'name': 'Арабіка'}),
      );
    });

    test('beans differing in any field are not equal', () {
      final bean = Bean.fromJson(const {'id': 7, 'name': 'Арабіка'});
      expect(bean, isNot(Bean.fromJson(const {'id': 8, 'name': 'Арабіка'})));
      expect(bean, isNot(Bean.fromJson(const {'id': 7, 'name': 'Бразилія'})));
    });

    test('groups compare their nested beans list', () {
      Map<String, dynamic> payload(int beanId) => {
            'id': 3,
            'name': 'Арабіка',
            'beans': [
              {'id': beanId, 'name': 'Колумбія'},
            ],
          };

      expect(
        BeanGroup.fromJson(payload(1)),
        BeanGroup.fromJson(payload(1)),
      );
      expect(
        BeanGroup.fromJson(payload(1)),
        isNot(BeanGroup.fromJson(payload(2))),
      );
    });

    test('hashCode matches for equal beans', () {
      final bean = Bean.fromJson(const {'id': 7, 'name': 'Арабіка'});
      expect(
        bean.hashCode,
        Bean.fromJson(const {'id': 7, 'name': 'Арабіка'}).hashCode,
      );
    });
  });
}
