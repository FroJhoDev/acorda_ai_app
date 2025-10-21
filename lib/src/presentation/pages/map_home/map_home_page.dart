import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/location_alarm.dart';
import '../../../core/injections/dependency_injection_simple.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../alarms_list/alarms_list_page.dart';
import '../alarm_form/alarm_form_page.dart';
import '../alarm_active/alarm_active_page.dart';

/// Página principal com mapa interativo
class MapHomePage extends StatefulWidget {
  const MapHomePage({super.key});

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  late final HomeViewModel _viewModel;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng? _userLocation;

  // Localização inicial padrão (São Paulo) - usado apenas se não conseguir pegar a localização real
  static const LatLng _defaultLocation = LatLng(-23.5505, -46.6333);

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>();

    // IMPORTANTE: Configura o callback ANTES de inicializar
    _viewModel.onAlarmTriggered = (alarm) {
      debugPrint('🚨 UI RECEBEU ALARME: ${alarm.title}');
      _navigateToActiveAlarm(alarm);
    };

    // Configura os callbacks internos do ViewModel
    _viewModel.setupCallbacks();

    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    debugPrint('📍 Inicializando ViewModel e monitoramento...');
    await _viewModel.initialize();

    // Atualiza localização do usuário
    _updateUserLocation();

    _loadMarkers();
    debugPrint(
        '✅ ViewModel inicializado. Monitoramento ativo: ${_viewModel.isMonitoring}');
  }

  /// Atualiza a localização atual do usuário
  void _updateUserLocation() {
    if (_viewModel.currentLocation != null) {
      setState(() {
        _userLocation = LatLng(
          _viewModel.currentLocation!.latitude,
          _viewModel.currentLocation!.longitude,
        );
      });

      debugPrint('📍 Localização do usuário: $_userLocation');

      // Move a câmera para a localização atual
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 14),
      );
    }
  }

  /// Navega para a página de alarme ativo
  void _navigateToActiveAlarm(LocationAlarm alarm) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlarmActivePage(
          alarm: alarm,
        ),
        settings: const RouteSettings(name: '/alarm-active'),
      ),
    );
    // Atualizar após voltar da tela de alarme
    _viewModel.refresh();
    _loadMarkers();
  }

  void _loadMarkers() {
    if (!mounted) return;

    setState(() {
      _markers.clear();

      // Adiciona marcador da localização atual do usuário (laranja)
      if (_userLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: _userLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
            infoWindow: const InfoWindow(
              title: '📍 Você está aqui',
              snippet: 'Sua localização atual',
            ),
          ),
        );
      }

      // Adiciona marcadores dos alarmes
      for (var alarm in _viewModel.alarms) {
        _markers.add(
          Marker(
            markerId: MarkerId(alarm.id),
            position: LatLng(alarm.latitude, alarm.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              alarm.isActive
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: alarm.title,
              snippet: alarm.isActive ? 'Ativo' : 'Inativo',
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  int _getActiveCount() {
    return _viewModel.alarms.where((alarm) => alarm.isActive).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlarmsListPage(),
              ),
            );
            // Recarrega após voltar da lista
            _viewModel.refresh();
            _loadMarkers();
          },
        ),
        title: const Text('AcordaAI'),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return Text(
                    '${_getActiveCount()} Ativos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _viewModel.refresh();
              _loadMarkers();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_viewModel.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
            });
          }

          return Stack(
            children: [
              // Mapa
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation ?? _defaultLocation,
                  zoom: 14,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  // Move para a localização do usuário quando o mapa é criado
                  if (_userLocation != null) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(_userLocation!, 14),
                    );
                  }
                },
                onTap: (location) {
                  _showCreateAlarmBottomSheet(location);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // Controles do mapa (direita)
              Positioned(
                right: AppSpacing.md,
                top: MediaQuery.of(context).padding.top + AppSpacing.md,
                child: Column(
                  children: [
                    _MapControlButton(
                      icon: Icons.add,
                      onPressed: () {
                        _mapController?.animateCamera(
                          CameraUpdate.zoomIn(),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MapControlButton(
                      icon: Icons.remove,
                      onPressed: () {
                        _mapController?.animateCamera(
                          CameraUpdate.zoomOut(),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MapControlButton(
                      icon: Icons.my_location,
                      backgroundColor: AppColors.accent,
                      onPressed: () async {
                        // Atualiza localização primeiro
                        await _viewModel.getCurrentLocation();
                        _updateUserLocation();
                        _loadMarkers();

                        // Move câmera para localização atualizada
                        if (_userLocation != null) {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(_userLocation!, 16),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Loading indicator
              if (_viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AlarmFormPage(),
            ),
          );

          // Recarrega após criar alarme
          if (result == true || mounted) {
            _viewModel.refresh();
            _loadMarkers();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }

  void _showCreateAlarmBottomSheet(LatLng location) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Criar Alarme Aqui?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlarmFormPage(
                            preselectedLocation: location,
                          ),
                        ),
                      );

                      // Recarrega após criar alarme
                      if (result == true || mounted) {
                        _viewModel.refresh();
                        _loadMarkers();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Criar Alarme'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão de controle do mapa
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(
              icon,
              color: backgroundColor != null
                  ? Colors.white
                  : AppColors.iconPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
