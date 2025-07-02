import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shimmer/shimmer.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool _loading = true;
  bool _permissionDenied = false;
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoad();
  }

  Future<void> _checkPermissionAndLoad() async {
    final status = await Permission.contacts.status;
    if (status.isGranted) {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
        setState(() {
          _allContacts = contacts;
          _filteredContacts = contacts;
          _loading = false;
          _permissionDenied = false;
        });
      } else {
        setState(() {
          _loading = false;
          _permissionDenied = true;
        });
      }
    } else {
      setState(() {
        _loading = false;
        _permissionDenied = true;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts.where((c) {
          final name = c.displayName.toLowerCase();
          final email = c.emails.isNotEmpty ? c.emails.first.address.toLowerCase() : '';
          return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _requestPermission() async {
    setState(() => _loading = true);
    final result = await Permission.contacts.request();
    if (result.isGranted) {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
        setState(() {
          _allContacts = contacts;
          _filteredContacts = contacts;
          _loading = false;
          _permissionDenied = false;
        });
      } else {
        setState(() {
          _loading = false;
          _permissionDenied = true;
        });
      }
    } else {
      setState(() {
        _loading = false;
        _permissionDenied = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF101014),
        body: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[700]!,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, i) => ListTile(
                leading: const CircleAvatar(radius: 24, backgroundColor: Colors.white24),
                title: Container(height: 16, width: 120, color: Colors.white24),
                subtitle: Container(height: 12, width: 80, color: Colors.white24),
              ),
            ),
          ),
        ),
      );
    }
    if (_permissionDenied) {
      return Scaffold(
        backgroundColor: const Color(0xFF101014),
        appBar: AppBar(
          title: const Text('Contacts'),
          backgroundColor: const Color(0xFF18181C),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.contacts, size: 64, color: Colors.amber),
              const SizedBox(height: 24),
              const Text('Contacts permission required', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _requestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(180, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: const Color(0xFF18181C),
      ),
      backgroundColor: const Color(0xFF101014),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search contacts',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF18181C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(child: Text('No contacts found', style: TextStyle(color: Colors.white70)))
                : ListView.separated(
                    itemCount: _filteredContacts.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                    itemBuilder: (context, i) {
                      final c = _filteredContacts[i];
                      return ListTile(
                        leading: (c.photo != null && c.photo!.isNotEmpty)
                            ? CircleAvatar(backgroundImage: MemoryImage(c.photo!))
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(c.displayName, style: const TextStyle(color: Colors.white)),
                        subtitle: Text((c.emails.isNotEmpty) ? c.emails.first.address : '', style: const TextStyle(color: Colors.white70)),
                        onTap: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}