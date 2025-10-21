import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../components/alarm_list_item.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/injections/dependency_injection_simple.dart';
import '../alarm_form/alarm_form_page.dart';
import '../alarm_active/alarm_active_page.dart';

/// Tela principal do aplicativo
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel _viewModel;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>();

    // Configura o callback para quando um alarme dispara
    _viewModel.onAlarmTriggered = (alarm) {
      debugPrint('🚨 UI RECEBEU ALARME: ${alarm.title}');
      _navigateToActiveAlarm(alarm);
    };

    // Configura os callbacks internos do ViewModel
    _viewModel.setupCallbacks();

    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initialize();
  }

  /// Navega para a página de alarme ativo
  void _navigateToActiveAlarm(alarm) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlarmActivePage(
          alarm: alarm,
        ),
        settings: const RouteSettings(name: '/alarm-active'),
      ),
    );
    // Recarrega os alarmes quando volta da tela
    _viewModel.refresh();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _viewModel.refresh,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog(_viewModel.errorMessage!);
            });
          }

          return IndexedStack(
            index: _selectedIndex,
            children: [
              _buildMapView(),
              _buildListView(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAlarmForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMapView() {
    if (_viewModel.currentLocation == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Obtendo localização...'),
          ],
        ),
      );
    }

    final initialPosition = LatLng(
      _viewModel.currentLocation!.latitude,
      _viewModel.currentLocation!.longitude,
    );

    // Cria marcadores para os alarmes
    final markers = <Marker>{};

    // Marcador da localização atual
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: initialPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: AppStrings.currentLocation),
      ),
    );

    // Marcadores dos alarmes
    for (final alarm in _viewModel.alarms) {
      markers.add(
        Marker(
          markerId: MarkerId(alarm.id),
          position: LatLng(alarm.latitude, alarm.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            alarm.isActive
                ? (alarm.isTriggered
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueGreen)
                : BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(
            title: alarm.title,
            snippet: alarm.description,
          ),
          onTap: () => _showAlarmDetails(alarm),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: AppConstants.defaultMapZoom,
      ),
      onMapCreated: (controller) {
        // Map controller could be stored if needed for future use
      },
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      onTap: _onMapTapped,
    );
  }

  Widget _buildListView() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.alarms.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.noAlarmsMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              AppStrings.createFirstAlarm,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _viewModel.alarms.length,
        itemBuilder: (context, index) {
          final alarm = _viewModel.alarms[index];
          return AlarmListItem(
            alarm: alarm,
            onTap: () => _showAlarmDetails(alarm),
            onToggle: (isActive) => _toggleAlarm(alarm.id, isActive),
          );
        },
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    // Navegar para o formulário de criação de alarme com a posição selecionada
    _navigateToAlarmForm(preselectedLocation: position);
  }

  void _navigateToAlarmForm({LatLng? preselectedLocation}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AlarmFormPage(
          preselectedLocation: preselectedLocation,
        ),
      ),
    )
        .then((_) {
      // Recarrega os alarmes quando voltar da tela de criação
      _viewModel.loadAlarms();
    });
  }

  void _showAlarmDetails(alarm) {
    // TODO: Implementar tela de detalhes do alarme
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alarm.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${alarm.description}'),
            const SizedBox(height: 8),
            Text('Raio: ${alarm.radius.toInt()} metros'),
            const SizedBox(height: 8),
            Text(
                'Status: ${alarm.isActive ? AppStrings.alarmActive : AppStrings.alarmInactive}'),
            if (alarm.isTriggered) ...[
              const SizedBox(height: 8),
              const Text('Alarme foi disparado!',
                  style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }

  void _toggleAlarm(String alarmId, bool isActive) {
    // TODO: Implementar toggle do alarme
    debugPrint('Toggle alarm $alarmId to $isActive');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }
}
