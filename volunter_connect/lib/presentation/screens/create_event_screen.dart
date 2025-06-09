
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunter_connect/application/blocs/event_creation_bloc.dart';
import 'package:volunter_connect/domain/models/event_model.dart';
import 'package:volunter_connect/domain/models/user_model.dart';

class CreateEventScreen extends StatefulWidget {
  final User user;
  const CreateEventScreen({super.key, required this.user});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedCategory;

  final List<String> _categories = [
    'Seniors',
    'Community',
    'Education',
    'Animals',
    'Environment',
    'Health'
  ];

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      subtitle: '',
      category: _selectedCategory!,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      time: '${_startTime!.format(context)} - ${_endTime!.format(context)}',
      location: _locationController.text,
      spotsLeft: 25,
      description: _descriptionController.text,
      requirements: {},
      additionalInfo: {},
      contactPhone: '',
      contactEmail: '',
      contactTelegram: '',
      // imageUrl: 'https://fake.url/uploaded-image.jpg',
    );

    context.read<EventCreationBloc>().add(CreateEventRequested(event: event, token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocConsumer<EventCreationBloc, EventCreationState>(
        listener: (context, state) {
          if (state is EventCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event created successfully!')),
            );
            Navigator.pop(context);
          } else if (state is EventCreationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Create New Post',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Fill in the details for your volunteer Activity',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              hintText: 'Day / Month / Year',
                            ),
                            controller: TextEditingController(
                              text: _selectedDate == null
                                  ? ''
                                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartTime,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: 'Start Time'),
                            controller: TextEditingController(
                              text: _startTime == null ? '' : _startTime!.format(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickEndTime,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: 'End Time'),
                            controller: TextEditingController(
                              text: _endTime == null ? '' : _endTime!.format(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _categories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedCategory = cat);
                      },
                      selectedColor: Colors.blue.shade100,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage == null
                        ? const Center(child: Icon(Icons.upload, size: 40))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                if (state is EventCreationLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _submitForm,
                    child: const Text('Create Event'),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
