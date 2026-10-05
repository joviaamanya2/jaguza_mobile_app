import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  String? _scannedValue;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scannedValue != null) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null || value.isEmpty) continue;
      setState(() => _scannedValue = value);
      _controller.stop();
      break;
    }
  }

  Future<void> _scanAgain() async {
    setState(() => _scannedValue = null);
    await _controller.start();
  }

  Future<void> _openScannedContent() async {
    final value = _scannedValue?.trim();
    if (value == null || value.isEmpty) return;

    final parsed = Uri.tryParse(value);
    final uri = parsed != null &&
            (parsed.scheme == 'http' || parsed.scheme == 'https')
        ? parsed
        : Uri.tryParse('https://$value');

    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showOpenError('This QR code does not contain a web link.');
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (opened && mounted) {
        Navigator.pop(context, value);
      } else if (mounted) {
        _showOpenError('Could not open this link in the browser.');
      }
    } catch (_) {
      if (mounted) _showOpenError('Could not open this link in the browser.');
    }
  }

  void _showOpenError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR code'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) => IconButton(
              tooltip: state.torchState == TorchState.on
                  ? 'Turn flash off'
                  : 'Turn flash on',
              onPressed: _controller.toggleTorch,
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Switch camera',
            onPressed: _controller.switchCamera,
            icon: const Icon(Icons.flip_camera_ios_rounded),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  error.errorCode == MobileScannerErrorCode.permissionDenied
                      ? 'Camera access is needed to scan a QR code. Allow camera access in your phone settings and try again.'
                      : 'The camera could not be started. Please check camera access and try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
          if (_scannedValue == null)
            const Positioned(
              left: 24,
              right: 24,
              bottom: 44,
              child: Text(
                'Place the QR code inside the frame to scan it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                ),
              ),
            )
          else
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Card(
                color: colors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR code scanned',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(_scannedValue!),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _scanAgain,
                            child: const Text('Scan again'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _openScannedContent,
                            child: const Text('Open'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
