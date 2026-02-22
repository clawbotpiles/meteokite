import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';

class WebcamPlayerPage extends StatefulWidget {
  const WebcamPlayerPage({
    super.key,
    required this.webcamName,
    required this.source,
    required this.status,
    required this.resolution,
  });

  final String webcamName;
  final String source;
  final String status;
  final String resolution;

  @override
  State<WebcamPlayerPage> createState() => _WebcamPlayerPageState();
}

class _WebcamPlayerPageState extends State<WebcamPlayerPage> {
  String _quality = 'Auto';
  bool _mute = true;

  List<({String title, String url})> _relatedWebcamPages() {
    final webcamName = widget.webcamName.toLowerCase();
    if (webcamName.contains('oliva')) {
      return const [
        (
          title: 'Oliva Puerto · Comunitat Valenciana',
          url:
              'https://www.comunitatvalenciana.com/es/valencia/oliva/webcams/oliva-puerto',
        ),
        (title: 'Portal webcams de olas', url: 'https://www.windguru.cz/'),
      ];
    }

    return const [
      (title: 'Portal webcams de olas', url: 'https://www.windguru.cz/'),
    ];
  }

  void _openFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _WebcamFullscreenView(webcamName: widget.webcamName),
      ),
    );
  }

  void _openRelatedPage(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abriremos esta pagina en la segunda fase: $url')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.webcamName)),
      body: ScrollConfiguration(
        behavior: const _NoStretchScrollBehavior(),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F172A), Color(0xFF334155)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.videocam_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Pantalla completa',
                        onPressed: _openFullscreen,
                        icon: const Icon(Icons.fullscreen_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fuente: ${widget.source}'),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Estado: ${widget.status}'),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Resolucion base: ${widget.resolution}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _quality,
                    decoration: const InputDecoration(
                      labelText: 'Calidad',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Auto', child: Text('Auto')),
                      DropdownMenuItem(value: '1080p', child: Text('1080p')),
                      DropdownMenuItem(value: '720p', child: Text('720p')),
                      DropdownMenuItem(value: '480p', child: Text('480p')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _quality = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filledTonal(
                  tooltip: _mute ? 'Activar audio' : 'Silenciar',
                  onPressed: () {
                    setState(() {
                      _mute = !_mute;
                    });
                  },
                  icon: Icon(
                    _mute ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Paginas con esta webcam',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            ..._relatedWebcamPages().map(
              (page) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(page.title),
                  subtitle: Text(page.url),
                  trailing: OutlinedButton.icon(
                    onPressed: () => _openRelatedPage(page.url),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Abrir pagina'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebcamFullscreenView extends StatelessWidget {
  const _WebcamFullscreenView({required this.webcamName});

  final String webcamName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(webcamName)),
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF334155)],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.videocam_rounded,
                color: Colors.white,
                size: 90,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
