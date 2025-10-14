import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/alarm_form_viewmodel.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/injections/dependency_injection_simple.dart';

/// Tela para criar/editar alarmes
class AlarmFormPage extends StatefulWidget {
  final LatLng? preselectedLocation;

  const AlarmFormPage({
    super.key,
    this.preselectedLocation,
  });

  @override
  State<AlarmFormPage> createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  late final AlarmFormViewModel _viewModel;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<AlarmFormViewModel>();
    _selectedLocation = widget.preselectedLocation;

    if (_selectedLocation != null) {
      _viewModel.setLocation(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createAlarmTitle),
        actions: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return TextButton(
                onPressed: _viewModel.isFormValid ? _saveAlarm : null,
                child: _viewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.save),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }

          if (_viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_viewModel.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            });
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMapSection(),
                ),
                Expanded(
                  flex: 3,
                  child: _buildFormSection(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ??
                  const LatLng(-23.5505, -46.6333), // São Paulo como padrão
              zoom: AppConstants.defaultMapZoom,
            ),
            onMapCreated: (controller) {
              // Map controller could be stored if needed for future use
            },
            onTap: _onMapTapped,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation!,
                      draggable: true,
                      onDragEnd: _onMarkerDragEnd,
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _selectedLocation != null
                      ? 'Localização selecionada'
                      : AppStrings.selectLocationHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: AppStrings.alarmTitle,
              hintText: AppStrings.alarmTitleHint,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um título';
              }
              return null;
            },
            onChanged: _viewModel.setTitle,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: AppStrings.alarmDescription,
              hintText: AppStrings.alarmDescriptionHint,
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma descrição';
              }
              return null;
            },
            onChanged: _viewModel.setDescription,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            AppStrings.alarmRadius,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Slider(
            value: _viewModel.radius,
            min: AppConstants.minAlarmRadius,
            max: AppConstants.maxAlarmRadius,
            divisions: 19, // 10m increments up to 200m, then larger increments
            label: '${_viewModel.radius.toInt()}m',
            onChanged: _viewModel.setRadius,
          ),
          Text(
            '${_viewModel.radius.toInt()} metros',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.soundSettings,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  SwitchListTile(
                    title: const Text(AppStrings.enableVibration),
                    value: _viewModel.vibrationEnabled,
                    onChanged: _viewModel.setVibrationEnabled,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Row(
                    children: [
                      const Icon(Icons.volume_down),
                      Expanded(
                        child: Slider(
                          value: _viewModel.volume.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 10,
                          label: '${_viewModel.volume}%',
                          onChanged: (value) =>
                              _viewModel.setVolume(value.toInt()),
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ),
                  Text(
                    '${AppStrings.volume}: ${_viewModel.volume}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _viewModel.setLocation(position.latitude, position.longitude);
  }

  void _onMarkerDragEnd(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _viewModel.setLocation(position.latitude, position.longitude);
  }

  void _saveAlarm() {
    if (_formKey.currentState?.validate() ?? false) {
      _viewModel.createAlarm();
    }
  }
}
