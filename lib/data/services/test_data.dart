import 'package:prro/data/models/seller_item.dart';

const List<Item> listOfCategories = [
  Category(
    id: '1',
    name: 'Електроніка',

    items: [
      Category(
        id: '1_1',
        name: 'Мобільні телефони',
        items: [
          Product(
            id: '1',
            name: 'iPhone 13',
            price: 999,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '2',
            name: 'Samsung Galaxy',
            price: 799,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
      Category(
        id: '1_2',
        name: 'Ноутбуки',
        items: [
          Product(
            id: '3',
            name: 'MacBook Pro',
            price: 1999,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '4',
            name: 'Dell XPS',
            price: 1499,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '9',
            name: 'xiaomi',
            price: 42,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
    ],
  ),
  Category(
    id: '2',
    name: 'Одежда',

    items: [
      Category(
        id: '2_1',
        name: 'Чоловіча',
        items: [
          Product(
            id: '5',
            name: 'Футболка',
            price: 29.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '6',
            name: 'Штани',
            price: 49.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
      Category(
        id: '2_2',
        name: 'Жіноча',
        items: [
          Product(
            id: '7',
            name: 'Сукня',
            price: 59.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '8',
            name: 'Топ',
            price: 19.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
    ],
  ),
];
