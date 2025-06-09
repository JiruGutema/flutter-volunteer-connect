import 'package:flutter/material.dart';
import '../../domain/models/profile_model.dart';

class EditProfileForm extends StatefulWidget {
  final Profile user;
  final void Function(Profile) onSave;
  const EditProfileForm({Key? key, required this.user, required this.onSave})
      : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _email, _city, _phone, _bio;
  late TextEditingController _eventsCtrl, _hoursCtrl;
  late List<String> _skills, _interests;
  final _newSkill = TextEditingController();
  final _newInterest = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _name = TextEditingController(text: u.name);
    _email = TextEditingController(text: u.email);
    _city = TextEditingController(text: u.city);
    _phone = TextEditingController(text: u.phone);
    _bio = TextEditingController(text: u.bio);
    _eventsCtrl = TextEditingController(text: u.attendedEvents.toString());
    _hoursCtrl = TextEditingController(text: u.hoursVolunteered.toString());
    _skills = List.from(u.skills);
    _interests = List.from(u.interests);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(padding: const EdgeInsets.all(16), children: [
        // Basic Info
        TextFormField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _email,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _city,
          decoration: const InputDecoration(labelText: 'City'),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _phone,
          decoration: const InputDecoration(labelText: 'Phone'),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _bio,
          decoration: const InputDecoration(labelText: 'Bio'),
          maxLines: 3,
        ),

        const SizedBox(height: 16),
        // Skills
        const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: _skills
              .map((s) => InputChip(
            label: Text(s),
            onDeleted: () => setState(() => _skills.remove(s)),
          ))
              .toList(),
        ),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _newSkill,
              decoration: const InputDecoration(hintText: 'Add skill'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final v = _newSkill.text.trim();
              if (v.isNotEmpty) {
                setState(() {
                  _skills.add(v);
                  _newSkill.clear();
                });
              }
            },
          )
        ]),

        const SizedBox(height: 16),
        // Interests
        const Text('Interests', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: _interests
              .map((i) => InputChip(
            label: Text(i),
            onDeleted: () => setState(() => _interests.remove(i)),
          ))
              .toList(),
        ),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _newInterest,
              decoration: const InputDecoration(hintText: 'Add interest'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final v = _newInterest.text.trim();
              if (v.isNotEmpty) {
                setState(() {
                  _interests.add(v);
                  _newInterest.clear();
                });
              }
            },
          )
        ]),

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            // build new Profile manually—no model change needed
            final updated = Profile(
              id: widget.user.id,
              name: _name.text,
              email: _email.text,
              role: widget.user.role,
              city: _city.text,
              phone: _phone.text,
              bio: _bio.text,
              attendedEvents: int.parse(_eventsCtrl.text),
              hoursVolunteered: int.parse(_hoursCtrl.text),
              skills: _skills,
              interests: _interests,
            );
            widget.onSave(updated);
          },
          child: const Text('Save Changes'),
        ),
      ]),
    );
  }
}
