import 'package:flutter/material.dart';

void main() {
  runApp(const CalculationApp());
}

class CalculationApp extends StatelessWidget {
  const CalculationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حساب الأسهم',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const CalculationPage(),
    );
  }
}

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  // Input Controllers for Total Area
  final TextEditingController _totalDonumController = TextEditingController();
  final TextEditingController _totalOlukController = TextEditingController();
  final TextEditingController _totalSqMeterController = TextEditingController();
  final TextEditingController _totalSharesController = TextEditingController();
  final TextEditingController _individualShareController =
      TextEditingController();

  // Output Controllers for Individual's Area
  final TextEditingController _resultDonumController = TextEditingController();
  final TextEditingController _resultOlukController = TextEditingController();
  final TextEditingController _resultSqMeterController =
      TextEditingController();

  // Unit conversion factors
  static const double donumToSqMeter = 2500.0;
  static const double olukToSqMeter = 100.0;

  @override
  void dispose() {
    _totalDonumController.dispose();
    _totalOlukController.dispose();
    _totalSqMeterController.dispose();
    _totalSharesController.dispose();
    _individualShareController.dispose();
    _resultDonumController.dispose();
    _resultOlukController.dispose();
    _resultSqMeterController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    _clearResults();

    // Get values from all three input fields and handle potential parsing errors
    double donumValue = double.tryParse(_totalDonumController.text) ?? 0;
    double olukValue = double.tryParse(_totalOlukController.text) ?? 0;
    double sqMeterValue = double.tryParse(_totalSqMeterController.text) ?? 0;

    // Convert all values to a single unit (Sq Meters) and sum them up
    double totalAreaInSqMeters =
        (donumValue * donumToSqMeter) +
        (olukValue * olukToSqMeter) +
        sqMeterValue;

    // Get shares from controllers
    final totalShares = double.tryParse(_totalSharesController.text) ?? 0;
    final individualShare =
        double.tryParse(_individualShareController.text) ?? 0;

    // Basic validation
    if (totalShares == 0 || individualShare == 0) {
      _resultSqMeterController.text = 'أدخل قيمًا صحيحة';
      return;
    }

    // Perform the main calculation
    double individualAreaInSqMeters =
        (totalAreaInSqMeters / totalShares) * individualShare;

    // Convert and display the result using the cascading logic
    int donum = (individualAreaInSqMeters / donumToSqMeter).floor();
    double remainingSqMeters = individualAreaInSqMeters % donumToSqMeter;

    int oluk = (remainingSqMeters / olukToSqMeter).floor();
    double finalSqMeters = remainingSqMeters % olukToSqMeter;

    _resultDonumController.text = donum.toString();
    _resultOlukController.text = oluk.toString();
    _resultSqMeterController.text = finalSqMeters.toStringAsFixed(2);
  }

  void _clearResults() {
    _resultDonumController.clear();
    _resultOlukController.clear();
    _resultSqMeterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حساب الأسهم',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image section
            Center(
              child: Image.asset(
                'images/1.png',
                height: 150, // Adjust size as needed
              ),
            ),
            const SizedBox(height: 20),

            // Main content section inside a Card for a clean look
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'الـــمــســاحـــــة الـــكلـــية:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildAreaInputRow(
                      'دونم',
                      _totalDonumController,
                      'أولك',
                      _totalOlukController,
                      'متر مربع',
                      _totalSqMeterController,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _totalSharesController,
                      labelText: 'عدد الحصص الكلية',
                      icon: Icons.people_alt_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _individualShareController,
                      labelText: 'حصة الشخص',
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _calculateArea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'احــــســــب الـــمـــســاحــة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'مساحة حصة الشخص:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildAreaInputRow(
                      'دونم',
                      _resultDonumController,
                      'أولك',
                      _resultOlukController,
                      'متر مربع',
                      _resultSqMeterController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Footer Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '© Ahmed Salim',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to build a reusable input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey[100] : Colors.white,
      ),
    );
  }

  // A helper function to build the row of 3 area input/output fields
  Widget _buildAreaInputRow(
    String label1,
    TextEditingController controller1,
    String label2,
    TextEditingController controller2,
    String label3,
    TextEditingController controller3, {
    bool readOnly = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildInputField(
            controller: controller1,
            labelText: label1,
            readOnly: readOnly,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInputField(
            controller: controller2,
            labelText: label2,
            readOnly: readOnly,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInputField(
            controller: controller3,
            labelText: label3,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
