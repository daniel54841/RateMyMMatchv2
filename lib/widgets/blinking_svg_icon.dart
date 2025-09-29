import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlinkingSvgIcon extends StatefulWidget {
  final String assetName;
  final double size;
  final Color? color;
  final Duration blinkDuration;
  final double minOpacity;
  final double maxOpacity;

  const BlinkingSvgIcon({
    Key? key,
    required this.assetName,
    this.size = 24.0, // Tamaño por defecto del icono
    this.color,       // Color por defecto (se tomará el del SVG si es null)
    this.blinkDuration = const Duration(milliseconds: 800),
    this.minOpacity = 0.3,
    this.maxOpacity = 1.0,
  }) : super(key: key);

  @override
  _BlinkingSvgIconState createState() => _BlinkingSvgIconState();
}

class _BlinkingSvgIconState extends State<BlinkingSvgIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.blinkDuration,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation( // Puedes usar CurvedAnimation para suavizar
      parent: _animationController,
      curve: Curves.easeInOut, // O cualquier otra curva que te guste
    ));

    // Hace que la animación se repita hacia adelante y hacia atrás
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SvgPicture.asset(
        widget.assetName,
        width: widget.size,
        height: widget.size,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null, // Aplica color si se proporciona
        placeholderBuilder: (BuildContext context) => Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: CircularProgressIndicator(strokeWidth: 2.0), // Placeholder mientras carga
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// --- Ejemplo de Uso ---
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Blinking SVG Icon')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Icono 'Live' Parpadeando:"),
              SizedBox(height: 10),
              BlinkingSvgIcon(
                assetName: 'assets/icons/live.svg', // RUTA A TU ICONO
                size: 50.0,
                color: Colors.red, // Ejemplo de color aplicado al SVG
                blinkDuration: Duration(milliseconds: 600),
                minOpacity: 0.1,
              ),
              SizedBox(height: 30),
              Text("Otro icono (ejemplo con estrella):"),
              SizedBox(height: 10),
              // Asegúrate de tener un 'star.svg' en 'assets/icons/' para probar esto
              BlinkingSvgIcon(
                assetName: 'assets/icons/star.svg', // REEMPLAZA O AÑADE ESTE SVG
                size: 40.0,
                color: Colors.amber,
                blinkDuration: Duration(seconds: 1),
                minOpacity: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
