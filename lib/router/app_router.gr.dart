// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:prro/features/admin/admin_shell.dart' as _i1;
import 'package:prro/features/admin/items/items_screen.dart' as _i3;
import 'package:prro/features/admin/items/screens/category_detail_screen.dart'
    as _i2;
import 'package:prro/features/admin/items/screens/product_detail_screen.dart'
    as _i11;
import 'package:prro/features/admin/items/screens/variant_detail_screen.dart'
    as _i16;
import 'package:prro/features/admin/orders/orders_screen.dart' as _i9;
import 'package:prro/features/admin/orders/screens/order_detail_screen.dart'
    as _i5;
import 'package:prro/features/admin/orders/screens/orders_history_screen.dart'
    as _i7;
import 'package:prro/features/admin/orders/screens/shifts_history_screen.dart'
    as _i13;
import 'package:prro/features/admin/outlets/outlets_screen.dart' as _i10;
import 'package:prro/features/admin/tellers/tellers_screen.dart' as _i15;
import 'package:prro/features/auth/screens/login_screen.dart' as _i4;
import 'package:prro/features/seller/screens/order_history/order_detail_screen.dart'
    as _i6;
import 'package:prro/features/seller/screens/order_history/orders_history_screen.dart'
    as _i8;
import 'package:prro/features/seller/screens/order_history/shifts_history_screen.dart'
    as _i14;
import 'package:prro/features/seller/screens/seller_screen.dart' as _i12;

/// generated route for
/// [_i1.AdminShell]
class AdminRoute extends _i17.PageRouteInfo<void> {
  const AdminRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminRoute.name, initialChildren: children);

  static const String name = 'AdminRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminShell();
    },
  );
}

/// generated route for
/// [_i2.CategoryDetailScreen]
class AdminCategoryDetailRoute
    extends _i17.PageRouteInfo<AdminCategoryDetailRouteArgs> {
  AdminCategoryDetailRoute({
    required int outletId,
    required int categoryId,
    required String categoryName,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         AdminCategoryDetailRoute.name,
         args: AdminCategoryDetailRouteArgs(
           outletId: outletId,
           categoryId: categoryId,
           categoryName: categoryName,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AdminCategoryDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminCategoryDetailRouteArgs>();
      return _i2.CategoryDetailScreen(
        outletId: args.outletId,
        categoryId: args.categoryId,
        categoryName: args.categoryName,
        key: args.key,
      );
    },
  );
}

class AdminCategoryDetailRouteArgs {
  const AdminCategoryDetailRouteArgs({
    required this.outletId,
    required this.categoryId,
    required this.categoryName,
    this.key,
  });

  final int outletId;

  final int categoryId;

  final String categoryName;

  final _i18.Key? key;

  @override
  String toString() {
    return 'AdminCategoryDetailRouteArgs{outletId: $outletId, categoryId: $categoryId, categoryName: $categoryName, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminCategoryDetailRouteArgs) return false;
    return outletId == other.outletId &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        key == other.key;
  }

  @override
  int get hashCode =>
      outletId.hashCode ^
      categoryId.hashCode ^
      categoryName.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i3.ItemsScreen]
class AdminItemsTabRoute extends _i17.PageRouteInfo<void> {
  const AdminItemsTabRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminItemsTabRoute.name, initialChildren: children);

  static const String name = 'AdminItemsTabRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i3.ItemsScreen();
    },
  );
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginScreen();
    },
  );
}

/// generated route for
/// [_i5.OrderDetailScreen]
class AdminOrderDetailRoute
    extends _i17.PageRouteInfo<AdminOrderDetailRouteArgs> {
  AdminOrderDetailRoute({
    required int orderId,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         AdminOrderDetailRoute.name,
         args: AdminOrderDetailRouteArgs(orderId: orderId, key: key),
         initialChildren: children,
       );

  static const String name = 'AdminOrderDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminOrderDetailRouteArgs>();
      return _i5.OrderDetailScreen(orderId: args.orderId, key: args.key);
    },
  );
}

class AdminOrderDetailRouteArgs {
  const AdminOrderDetailRouteArgs({required this.orderId, this.key});

  final int orderId;

  final _i18.Key? key;

  @override
  String toString() {
    return 'AdminOrderDetailRouteArgs{orderId: $orderId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminOrderDetailRouteArgs) return false;
    return orderId == other.orderId && key == other.key;
  }

  @override
  int get hashCode => orderId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i6.OrderDetailScreen]
class SellerOrderDetailRoute
    extends _i17.PageRouteInfo<SellerOrderDetailRouteArgs> {
  SellerOrderDetailRoute({
    required int orderId,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         SellerOrderDetailRoute.name,
         args: SellerOrderDetailRouteArgs(orderId: orderId, key: key),
         initialChildren: children,
       );

  static const String name = 'SellerOrderDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SellerOrderDetailRouteArgs>();
      return _i6.OrderDetailScreen(orderId: args.orderId, key: args.key);
    },
  );
}

class SellerOrderDetailRouteArgs {
  const SellerOrderDetailRouteArgs({required this.orderId, this.key});

  final int orderId;

  final _i18.Key? key;

  @override
  String toString() {
    return 'SellerOrderDetailRouteArgs{orderId: $orderId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SellerOrderDetailRouteArgs) return false;
    return orderId == other.orderId && key == other.key;
  }

  @override
  int get hashCode => orderId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i7.OrdersHistoryScreen]
class AdminOrdersHistoryRoute
    extends _i17.PageRouteInfo<AdminOrdersHistoryRouteArgs> {
  AdminOrdersHistoryRoute({
    required int shiftId,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         AdminOrdersHistoryRoute.name,
         args: AdminOrdersHistoryRouteArgs(shiftId: shiftId, key: key),
         initialChildren: children,
       );

  static const String name = 'AdminOrdersHistoryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminOrdersHistoryRouteArgs>();
      return _i7.OrdersHistoryScreen(shiftId: args.shiftId, key: args.key);
    },
  );
}

class AdminOrdersHistoryRouteArgs {
  const AdminOrdersHistoryRouteArgs({required this.shiftId, this.key});

  final int shiftId;

  final _i18.Key? key;

  @override
  String toString() {
    return 'AdminOrdersHistoryRouteArgs{shiftId: $shiftId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminOrdersHistoryRouteArgs) return false;
    return shiftId == other.shiftId && key == other.key;
  }

  @override
  int get hashCode => shiftId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i8.OrdersHistoryScreen]
class SellerOrdersHistoryRoute
    extends _i17.PageRouteInfo<SellerOrdersHistoryRouteArgs> {
  SellerOrdersHistoryRoute({
    required int shiftId,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         SellerOrdersHistoryRoute.name,
         args: SellerOrdersHistoryRouteArgs(shiftId: shiftId, key: key),
         initialChildren: children,
       );

  static const String name = 'SellerOrdersHistoryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SellerOrdersHistoryRouteArgs>();
      return _i8.OrdersHistoryScreen(shiftId: args.shiftId, key: args.key);
    },
  );
}

class SellerOrdersHistoryRouteArgs {
  const SellerOrdersHistoryRouteArgs({required this.shiftId, this.key});

  final int shiftId;

  final _i18.Key? key;

  @override
  String toString() {
    return 'SellerOrdersHistoryRouteArgs{shiftId: $shiftId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SellerOrdersHistoryRouteArgs) return false;
    return shiftId == other.shiftId && key == other.key;
  }

  @override
  int get hashCode => shiftId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i9.OrdersScreen]
class AdminOrdersTabRoute extends _i17.PageRouteInfo<void> {
  const AdminOrdersTabRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminOrdersTabRoute.name, initialChildren: children);

  static const String name = 'AdminOrdersTabRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.OrdersScreen();
    },
  );
}

/// generated route for
/// [_i10.OutletsScreen]
class AdminOutletsTabRoute extends _i17.PageRouteInfo<void> {
  const AdminOutletsTabRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminOutletsTabRoute.name, initialChildren: children);

  static const String name = 'AdminOutletsTabRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.OutletsScreen();
    },
  );
}

/// generated route for
/// [_i11.ProductDetailScreen]
class AdminProductDetailRoute
    extends _i17.PageRouteInfo<AdminProductDetailRouteArgs> {
  AdminProductDetailRoute({
    required int outletId,
    required int categoryId,
    required int productId,
    required String productName,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         AdminProductDetailRoute.name,
         args: AdminProductDetailRouteArgs(
           outletId: outletId,
           categoryId: categoryId,
           productId: productId,
           productName: productName,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AdminProductDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminProductDetailRouteArgs>();
      return _i11.ProductDetailScreen(
        outletId: args.outletId,
        categoryId: args.categoryId,
        productId: args.productId,
        productName: args.productName,
        key: args.key,
      );
    },
  );
}

class AdminProductDetailRouteArgs {
  const AdminProductDetailRouteArgs({
    required this.outletId,
    required this.categoryId,
    required this.productId,
    required this.productName,
    this.key,
  });

  final int outletId;

  final int categoryId;

  final int productId;

  final String productName;

  final _i18.Key? key;

  @override
  String toString() {
    return 'AdminProductDetailRouteArgs{outletId: $outletId, categoryId: $categoryId, productId: $productId, productName: $productName, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminProductDetailRouteArgs) return false;
    return outletId == other.outletId &&
        categoryId == other.categoryId &&
        productId == other.productId &&
        productName == other.productName &&
        key == other.key;
  }

  @override
  int get hashCode =>
      outletId.hashCode ^
      categoryId.hashCode ^
      productId.hashCode ^
      productName.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i12.SellerScreen]
class SellerRoute extends _i17.PageRouteInfo<void> {
  const SellerRoute({List<_i17.PageRouteInfo>? children})
    : super(SellerRoute.name, initialChildren: children);

  static const String name = 'SellerRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.SellerScreen();
    },
  );
}

/// generated route for
/// [_i13.ShiftsHistoryScreen]
class AdminShiftsHistoryRoute extends _i17.PageRouteInfo<void> {
  const AdminShiftsHistoryRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminShiftsHistoryRoute.name, initialChildren: children);

  static const String name = 'AdminShiftsHistoryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.ShiftsHistoryScreen();
    },
  );
}

/// generated route for
/// [_i14.ShiftsHistoryScreen]
class SellerShiftsHistoryRoute extends _i17.PageRouteInfo<void> {
  const SellerShiftsHistoryRoute({List<_i17.PageRouteInfo>? children})
    : super(SellerShiftsHistoryRoute.name, initialChildren: children);

  static const String name = 'SellerShiftsHistoryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.ShiftsHistoryScreen();
    },
  );
}

/// generated route for
/// [_i15.TellersScreen]
class AdminTellersTabRoute extends _i17.PageRouteInfo<void> {
  const AdminTellersTabRoute({List<_i17.PageRouteInfo>? children})
    : super(AdminTellersTabRoute.name, initialChildren: children);

  static const String name = 'AdminTellersTabRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.TellersScreen();
    },
  );
}

/// generated route for
/// [_i16.VariantDetailScreen]
class AdminVariantDetailRoute
    extends _i17.PageRouteInfo<AdminVariantDetailRouteArgs> {
  AdminVariantDetailRoute({
    required int outletId,
    required int categoryId,
    required int productId,
    required int variantId,
    required String variantName,
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         AdminVariantDetailRoute.name,
         args: AdminVariantDetailRouteArgs(
           outletId: outletId,
           categoryId: categoryId,
           productId: productId,
           variantId: variantId,
           variantName: variantName,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AdminVariantDetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminVariantDetailRouteArgs>();
      return _i16.VariantDetailScreen(
        outletId: args.outletId,
        categoryId: args.categoryId,
        productId: args.productId,
        variantId: args.variantId,
        variantName: args.variantName,
        key: args.key,
      );
    },
  );
}

class AdminVariantDetailRouteArgs {
  const AdminVariantDetailRouteArgs({
    required this.outletId,
    required this.categoryId,
    required this.productId,
    required this.variantId,
    required this.variantName,
    this.key,
  });

  final int outletId;

  final int categoryId;

  final int productId;

  final int variantId;

  final String variantName;

  final _i18.Key? key;

  @override
  String toString() {
    return 'AdminVariantDetailRouteArgs{outletId: $outletId, categoryId: $categoryId, productId: $productId, variantId: $variantId, variantName: $variantName, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminVariantDetailRouteArgs) return false;
    return outletId == other.outletId &&
        categoryId == other.categoryId &&
        productId == other.productId &&
        variantId == other.variantId &&
        variantName == other.variantName &&
        key == other.key;
  }

  @override
  int get hashCode =>
      outletId.hashCode ^
      categoryId.hashCode ^
      productId.hashCode ^
      variantId.hashCode ^
      variantName.hashCode ^
      key.hashCode;
}
