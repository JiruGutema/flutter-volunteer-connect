// lib/presentation/widgets/org_edit_profile_form.dart
import 'package:flutter/material.dart';
import '../../domain/models/profile_model.dart';

class OrgEditProfileForm extends StatefulWidget {
  final Profile user;
  final void Function(Profile) onSave;

  const OrgEditProfileForm({
    Key? key,
    required this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  _OrgEditProfileFormState createState() => _OrgEditProfileFormState();
}

class _OrgEditProfileFormState extends State<OrgEditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _email, _city, _phone, _bio;
  late List<String> _domains;
  final _newDomain = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _name = TextEditingController(text: u.name);
    _email = TextEditingController(text: u.email);
    _city = TextEditingController(text: u.city);
    _phone = TextEditingController(text: u.phone);
    _bio = TextEditingController(text: u.bio);
    // reuse `skills` as domains:
    _domains = List.from(u.skills);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _city.dispose();
    _phone.dispose();
    _bio.dispose();
    _newDomain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Basic Info
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Organization Name'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _city,
            decoration: const InputDecoration(labelText: 'City'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          // const SizedBox(height: 12),
          // TextFormField(
          //   controller: _bio,
          //   decoration: const InputDecoration(labelText: 'Bio'),
          //   maxLines: 3,
          // ),

          const SizedBox(height: 24),
          // Domains
          const Text('Domains', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _domains
                .map((d) => InputChip(
              label: Text(d),
              onDeleted: () => setState(() => _domains.remove(d)),
            ))
                .toList(),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newDomain,
                  decoration: const InputDecoration(hintText: 'Add domain'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final v = _newDomain.text.trim();
                  if (v.isNotEmpty) {
                    setState(() {
                      _domains.add(v);
                      _newDomain.clear();
                    });
                  }
                },
              )
            ],
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;

              final updated = Profile(
                id: widget.user.id,
                name: _name.text,
                email: _email.text,
                role: widget.user.role,
                city: _city.text,
                phone: _phone.text,
                bio: _bio.text,
                // no stats for org:
                attendedEvents: widget.user.attendedEvents,
                hoursVolunteered: widget.user.hoursVolunteered,
                skills: _domains,
                interests: widget.user.interests,
              );
              widget.onSave(updated);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
