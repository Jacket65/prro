import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prro/features/auth/screens/login_screen.dart';
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
// import 'package:prro/main_screen/main_screen_widgets/dialog_dpi.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';
import 'package:prro/features/admin/screens/main_screen/torgovi_tochki.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/features/admin/screens/tellers_screen/fill_teller_rows.dart';
import 'package:prro/features/admin/screens/tellers_screen/teller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int retailOutletId = 1;
  List<List<String>> tellerGroup = [];
  List<String> outletsData = [];
  List<List<String>> outletsDataList = [];
  List<dynamic> outlets = [];
  bool loadingMeasures = false;
  int? selectedRowIndex = 0;
  List<Measure> measures = [];

  @override
  void initState() {
    super.initState();
    _loadOutlets();
    _loadMeasures();
    for (int i = 0; i < userLenght; i++) {
      final List<String> tellerData = [
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["status2"],
      ];
      listOfTllers.add(fillTellerRows(extraText: tellerData));
    }
  }

  Future<void> _loadSellers() async {
    final data = await context.read<ApiService>().fetchRetailSeller(
      retailOutlet: outlets[0]['id'],
    );

    for (int j = 0; j < data.length; j++) {
      final List<String> sellersData = [
        "${data[j]['first_name']} ${data[j]['second_name']}",
        data[j]['id'].toString(),
        data[j]['retail_outlet_id'].toString(),
        'Not set',
      ];

      tellerGroup.add(sellersData);
      log("sellers $sellersData");
    }
  }

  Future<void> _loadOutlets() async {
    final api = context.read<ApiService>();
    setState(() {
      loadingMeasures = true;
    });
    try {
      final loginAdmin = await api.loginAdmin(
        phoneNumber: '+380123456789',
        password: '123456',
      );
      final list = await api.fetchRetailOutlets();
      outlets = list;
      _loadSellers();
      for (int i = 0; i < outlets.length; i++) {
        outletsDataList.add([
          outlets[i]['name'],
          'Not set',
          outlets[i]['id'].toString(),
          'Not set',
          'Not set',
          'Not set',
          'Not set',
        ]);
      }
      setState(() {});
      log("loginAdmin $loginAdmin");
      log("$outlets");
    } catch (e) {
      // обробка помилки, можливо перенаправлення на логін
      log('Error loading outlets: $e');
    } finally {
      setState(() {
        loadingMeasures = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
    final bool isSelected = selecteIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  selecteIndex = index;
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

  void _showDialog(String title) {
    showDialog(
      context: context,
      builder: (_) => Scaffold(),
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
            backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            DialogRoute(context: context, builder: (_) => LoginScreen()),
          ),
          child: const Text('Зберегти', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (currentContent) {
      case 'Торгові точки та ПРРО':
        return Ttochki(
          data: outletsDataList,
          selectedIndex: selectedRowIndex,
          onRowSelect: (index) {
            setState(() {
              selectedRowIndex = index;
              retailOutletId = int.parse(outletsDataList[index][2]);
            });
          },
        );
      case 'Касири':
        return Expanded(child: Teller(tellerGroup: tellerGroup));
      case 'Товари':
        return Expanded(
          child: MultiProvider(
            providers: [
              Provider<int>.value(value: retailOutletId),
              Provider<List<Measure>>.value(value: measures),
            ],
            child: Items(),
          ),
        );
      default:
        return const Text('В процесі');
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Future<void> _loadMeasures() async {
    final api = Provider.of<ApiService>(context, listen: false);
    setState(() {
      loadingMeasures = true;
    });
    try {
      measures = await api.fetchMeasures();
    } catch (e) {
      // обробка помилки, можливо перенаправлення на логін
      log('Error loading measures: $e');
    } finally {
      setState(() {
        loadingMeasures = false;
      });
    }
  }
}
