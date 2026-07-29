import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';
import 'package:prro/features/admin/screens/main_screen/torgovi_tochki.dart';
import 'package:prro/features/admin/screens/tellers_screen/teller.dart';
import 'package:prro/features/auth/screens/login_screen.dart';

final GetIt getIt = GetIt.instance;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int retailOutletId = -1;
  List<List<String>> tellerGroup = [];
  List<String> outletsData = [];
  List<List<String>> outletsDataList = [];
  List<Map<String, dynamic>> outlets = [];
  bool loadingMeasures = false;
  bool loadingSellers = false;
  int? selectedRowIndex;
  List<Measure> measures = [];
  int selectedIndex = 1;
  String currentContent = 'Торгові точки та ПРРО';

  @override
  void initState() {
    super.initState();
    unawaited(_loadOutlets());
    unawaited(_loadMeasures());
  }

  Future<void> _loadSellers(int outletId) async {
    setState(() {
      loadingSellers = true;
      tellerGroup = [];
    });
    try {
      final data = await getIt<ApiService>().fetchRetailSeller(
        retailOutlet: outletId,
      );
      final next = <List<String>>[];
      for (final raw in data) {
        final m = (raw as Map).cast<String, dynamic>();
        next.add([
          "${m['first_name'] ?? ''} ${m['last_name'] ?? ''}".trim(),
          (m['role'] ?? '').toString(),
          'Зареєстрований',
          'Active',
        ]);
      }
      if (!mounted) return;
      setState(() {
        tellerGroup = next;
      });
    } on Object catch (e) {
      log('Error loading sellers: $e');
    } finally {
      if (mounted) {
        setState(() {
          loadingSellers = false;
        });
      }
    }
  }

  Future<void> _loadOutlets() async {
    final api = getIt<ApiService>();
    if (!mounted) return;
    setState(() {
      loadingMeasures = true;
    });
    try {
      final loginAdmin = await api.loginAdmin(
        phoneNumber: 'admin',
        password: 'admin123',
      );
      final list = await api.fetchRetailOutlets();
      outlets = list;
      outletsDataList = [];
      for (var i = 0; i < outlets.length; i++) {
        outletsDataList.add([
          (outlets[i]['name'] as String?) ?? 'Unknown',
          'Not set',
          (outlets[i]['id'] as num?)?.toString() ?? '',
          'Not set',
          'Not set',
          'Not set',
          'Not set',
        ]);
      }
      // Auto-pick the first outlet so the rest of the UI
      // has something to work with
      if (outlets.isNotEmpty) {
        selectedRowIndex = 0;
        retailOutletId = (outlets.first['id'] as num?)?.toInt() ?? 0;
      }
      if (!mounted) return;
      setState(() {});
      if (retailOutletId > 0) {
        await _loadSellers(retailOutletId);
      }
      log('loginAdmin $loginAdmin');
      log('$outlets');
    } on Object catch (e) {
      // обробка помилки, можливо перенаправлення на логін
      log('Error loading outlets: $e');
    } finally {
      setState(() {
        loadingMeasures = false;
      });
    }
  }

  void _onOutletSelected(int index) {
    final id = int.parse(outletsDataList[index][2]);
    setState(() {
      selectedRowIndex = index;
      retailOutletId = id;
    });
    unawaited(_loadSellers(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _topBarButton(label: 'Торгові точки та ПРРО', index: 1),
            _topBarButton(label: 'Касири', index: 2),
            _topBarButton(label: 'Товари', index: 3),
            _topBarButton(label: 'Журнал', index: 4),
            _topBarButton(label: 'Звіти', index: 5),
            _topBarButton(label: 'Помилки', index: 6),
          ],
        ),
        if (currentContent == 'Торгові точки та ПРРО')
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () => _showDialog('Зазначте код ДПІ'),
            child: const Text(
              'Нова торгова точка',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _topBarButton({required String label, required int index}) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Colors.blue : Colors.white,
                  width: 2,
                ),
              ),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                  currentContent = label;
                });
              },
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog(String title) {
    return showDialog<void>(
      context: context,
      builder: (_) => const Scaffold(),
      // DialogDpi(title: title, rowsName: rowsList, fillRows: fillRows),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Програмний ПРРО "Каса"'),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.blueAccent),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            DialogRoute<void>(context: context, builder: (_) => LoginScreen()),
          ),
          child: const Text('Зберегти', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (retailOutletId <= 0 && currentContent != 'Торгові точки та ПРРО') {
      return const Expanded(
        child: Center(
          child: Text(
            'Спершу виберіть торгову точку у вкладці «Торгові точки та ПРРО».',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    switch (currentContent) {
      case 'Торгові точки та ПРРО':
        return Ttochki(
          data: outletsDataList,
          selectedIndex: selectedRowIndex,
          onRowSelect: _onOutletSelected,
        );
      case 'Касири':
        if (loadingSellers) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Expanded(
          // Rebuild Teller when outlet changes
          // so it picks up the new tellerGroup
          child: Teller(
            key: ValueKey('teller-$retailOutletId'),
            tellerGroup: tellerGroup,
          ),
        );
      case 'Товари':
        return Expanded(
          // Outlet change → drop & rebuild the items subtree so it re-fetches.
          child: Items(
            key: ValueKey('items-$retailOutletId'),
          ),
        );
      default:
        return const Text('В процесі');
    }
  }

  void _logout(BuildContext context) {
    unawaited(
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => LoginScreen()),
      ),
    );
  }

  Future<void> _loadMeasures() async {
    final api = getIt<ApiService>();
    if (!mounted) return;
    setState(() {
      loadingMeasures = true;
    });
    try {
      measures = await api.fetchMeasures();
    } on Object catch (e) {
      // обробка помилки, можливо перенаправлення на логін
      log('Error loading measures: $e');
    } finally {
      setState(() {
        loadingMeasures = false;
      });
    }
  }
}
