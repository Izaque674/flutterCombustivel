import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FuelComparisonScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FuelComparisonScreen extends StatefulWidget {
  @override
  _FuelComparisonScreenState createState() => _FuelComparisonScreenState();
}

class _FuelComparisonScreenState extends State<FuelComparisonScreen>
    with SingleTickerProviderStateMixin {
  final _alcoolController = TextEditingController();
  final _gasolinaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _resultado = "";
  double _opacity = 0.0;
  double _translation = 50.0;
  bool _isButtonPressed = false;

  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    // Configuração da animação do ícone
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _iconAnimation = Tween<double>(begin: 0.8, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_iconAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _iconAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _iconAnimationController.forward();
        }
      });

    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _alcoolController.dispose();
    _gasolinaController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final alcool = double.parse(_alcoolController.text);
      final gasolina = double.parse(_gasolinaController.text);

      setState(() {
        final razao = alcool / gasolina;
        _resultado = razao < 0.7 ? "Abasteça com Álcool" : "Abasteça com Gasolina";
        _opacity = 1.0;
        _translation = 0.0;
      });
    }
  }

  void _limparCampos() {
    _alcoolController.clear();
    _gasolinaController.clear();
    setState(() {
      _resultado = "";
      _opacity = 0.0;
      _translation = 50.0;
      _isButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comparador de Combustível"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AnimatedBuilder(
                animation: _iconAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconAnimation.value,
                    child: child,
                  );
                },
                child: Icon(
                  Icons.local_gas_station,
                  size: 100.0,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _alcoolController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Preço do Álcool (R\$)",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                style: TextStyle(fontSize: 18.0),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço do álcool.";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "O valor deve ser um número positivo.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _gasolinaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Preço da Gasolina (R\$)",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                style: TextStyle(fontSize: 18.0),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço da gasolina.";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "O valor deve ser um número positivo.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                        _calcular();
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: _isButtonPressed ? Colors.green[700] : Colors.green,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Calcular",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                        _limparCampos();
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: _isButtonPressed ? Colors.red[700] : Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Limpar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  transform: Matrix4.translationValues(0.0, _translation, 0.0),
                  child: Text(
                    _resultado,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: _resultado.contains("Álcool") ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
