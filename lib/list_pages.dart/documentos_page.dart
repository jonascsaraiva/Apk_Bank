import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DocumentosPage extends StatefulWidget {
  const DocumentosPage({super.key});

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        await _previewCamera(cameras.first);
      }
    } on CameraException catch (e) {
      debugPrint('Erro ao carregar câmeras: ${e.description}');
    }
  }

  Future<void> _previewCamera(CameraDescription camera) async {
    // Se já existe um controller, descarta antes de criar outro
    await controller?.dispose();

    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;
    try {
      await cameraController.initialize();
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      debugPrint('Erro ao inicializar câmera: ${e.description}');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documento Oficial'),
        backgroundColor: const Color.fromARGB(255, 15, 68, 124),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(child: _arquivoWidget()),
      ),
      floatingActionButton: (imagem != null)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context),
              label: const Text('Finalizar'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _arquivoWidget() {
    return Container(
      width: size!.width - 50,
      height: size!.height - (size!.height / 3),
      child: imagem == null
          ? _cameraPreviewWidget()
          : Image.file(File(imagem!.path), fit: BoxFit.contain),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(child: Text('Câmera não disponível'));
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [CameraPreview(cameraController), _botaoCapturaWidget()],
      );
    }
  }

  Widget _botaoCapturaWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black.withAlpha(5),
        child: IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
          onPressed: tirarFoto,
        ),
      ),
    );
  }

  Future<void> tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => imagem = file);
      } on CameraException catch (e) {
        debugPrint('Erro ao tirar foto: ${e.description}');
      }
    }
  }
}
