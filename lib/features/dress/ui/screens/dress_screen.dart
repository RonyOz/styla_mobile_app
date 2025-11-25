import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/dress_bloc.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/events/dress_event.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/states/dress_state.dart';

class VestirseScreen extends StatefulWidget {
  const VestirseScreen({Key? key}) : super(key: key);

  @override
  State<VestirseScreen> createState() => _VestirseScreenState();
}

class _VestirseScreenState extends State<VestirseScreen> {
  int _currentOutfitIndex = 0;
  late final TextEditingController _nameController;
  late final TextEditingController _moodController;
  late final TextEditingController _occasionController;
  String? _selectedShirt;
  String? _selectedPants;
  String? _selectedShoes;

  // SOLUCIÓN: Mantener los datos en el estado local
  List<Garment> _garments = [];
  List<dynamic> _outfits = []; // Cambia 'dynamic' por tu tipo de Outfit
  bool _isLoadingOutfits = true;
  bool _isLoadingGarments = true;

  final Map<String, String> _occasions = {
    'Invierno': '0cceab28-6239-440f-94d0-6447acec073b',
    'Otoño': '11cdcafb-47f7-4c06-b104-2ff304519568',
    'Fiesta': '318d6aef-9561-4ccd-b5fb-62e6dbe4327c',
    'Salir a comer': '3a6afb6f-2a53-4711-b525-a5c83db8651d',
    'Cita': '40a41743-3fa2-4d9a-825d-d8d69722d373',
    'Primavera': '503b0e9f-a6eb-4f52-90b2-eb84d6f22b56',
    'Playa': '964d9ef9-918f-4487-8022-94b600230fbc',
    'Verano': 'fcfd71b3-e1fa-4e8d-a065-67bc95bcd457',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _moodController = TextEditingController();
    _occasionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DressBloc>().add(LoadDressDataRequested());
      context.read<DressBloc>().add(LoadGarmentsDataRequested());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _moodController.dispose();
    _occasionController.dispose();
    super.dispose();
  }

  void _nextOutfit(int totalOutfits) {
    setState(() {
      _currentOutfitIndex = (_currentOutfitIndex + 1) % totalOutfits;
    });
  }

  void _previousOutfit(int totalOutfits) {
    setState(() {
      _currentOutfitIndex =
          (_currentOutfitIndex - 1 + totalOutfits) % totalOutfits;
    });
  }

  void _submitSelection() {
    if (_nameController.text.isEmpty ||
        _moodController.text.isEmpty ||
        _occasionController.text.isEmpty ||
        _selectedShirt == null ||
        _selectedPants == null ||
        _selectedShoes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    context.read<DressBloc>().add(
      SaveDressDataRequested(
        name: _nameController.text,
        description: _moodController.text,
        promptId: _occasionController.text,
        shirt: _selectedShirt!,
        pants: _selectedPants!,
        shoes: _selectedShoes!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Vestirse',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener<DressBloc, DressState>(
        listener: (context, state) {
          // SOLUCIÓN: Actualizar el estado local cuando llegan los datos
          if (state is DressDataLoadedState) {
            setState(() {
              _outfits = state.outfits;
              _isLoadingOutfits = false;
            });
          }

          if (state is GarmentsDataLoadedState) {
            setState(() {
              _garments = state.garments;
              _isLoadingGarments = false;
            });
          }

          if (state is DressErrorState) {
            setState(() {
              _isLoadingOutfits = false;
              _isLoadingGarments = false;
            });
          }

          if (state is DressSavedState) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Mostrar loading mientras se cargan los datos iniciales
    if (_isLoadingOutfits) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // Si no hay outfits, mostrar pantalla vacía
    if (_outfits.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checkroom, size: 120, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'Aún no tienes outfits planeados',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Mostrar el contenido principal
    return SingleChildScrollView(
      child: Column(
        children: [
          // Outfit centrado con navegación
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen del outfit con navegación
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => _previousOutfit(_outfits.length),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[800],
                        ),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _outfits[_currentOutfitIndex].imageUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[700],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => _nextOutfit(_outfits.length),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Nombre del outfit e indicador de posición
                Column(
                  children: [
                    Text(
                      _outfits[_currentOutfitIndex].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentOutfitIndex + 1}/${_outfits.length}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mood input y Selects
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Nombre del Outfit',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ej: Outfit casual para el fin de semana',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '¿Cuál es tu mood de hoy?',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _moodController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ej: Casual, Formal, Deportivo...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Mostrar loading o selectores según el estado
                if (_isLoadingGarments)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else if (_garments.isNotEmpty)
                  Column(
                    children: [
                      // Selector de Occasion
                      _buildOccasionSelector(),
                      const SizedBox(height: 12),
                      // Selector de Camisa
                      _buildGarmentSelector(
                        label: 'Camisa',
                        items: _garments,
                        selectedValue: _selectedShirt,
                        onChanged: (value) {
                          setState(() {
                            _selectedShirt = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      // Selector de Pantalón
                      _buildGarmentSelector(
                        label: 'Pantalón',
                        items: _garments,
                        selectedValue: _selectedPants,
                        onChanged: (value) {
                          setState(() {
                            _selectedPants = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      // Selector de Zapatos
                      _buildGarmentSelector(
                        label: 'Zapatos',
                        items: _garments,
                        selectedValue: _selectedShoes,
                        onChanged: (value) {
                          setState(() {
                            _selectedShoes = value;
                          });
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: 20),
                // Botón Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitSelection,
                    child: const Text(
                      'Guardar Outfit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGarmentSelector({
    required String label,
    required List<Garment> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: Text(
              'Selecciona $label',
              style: TextStyle(color: Colors.grey[600]),
            ),
            dropdownColor: Colors.grey[800],
            underline: SizedBox.shrink(),
            items: items.map((garment) {
              return DropdownMenuItem(
                value: garment.imageUrl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // Imagen del garment
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[700],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            garment.imageUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 16,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Nombre del garment
                      Expanded(
                        child: Text(
                          garment.occasion,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildOccasionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ocasión',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _occasionController.text.isEmpty
                ? null
                : _occasionController.text,
            hint: Text(
              'Selecciona Ocasión',
              style: TextStyle(color: Colors.grey[600]),
            ),
            dropdownColor: Colors.grey[800],
            underline: SizedBox.shrink(),
            items: _occasions.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    entry.key,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _occasionController.text = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
