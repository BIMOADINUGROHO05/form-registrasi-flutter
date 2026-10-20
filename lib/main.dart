import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendaftaran Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final namaFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  String? jenisKelamin;
  String? programStudi;
  bool setuju = false;
  bool passwordVisible = false;

  final List<String> programStudiList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();

    namaFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  String? validasiNama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  }

  String? validasiEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    if (!value.contains('@')) {
      return 'Email harus mengandung @';
    }

    return null;
  }

  String? validasiPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  void daftar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jenis kelamin'),
        ),
      );
      return;
    }

    if (!setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan'),
        ),
      );
      return;
    }

    tampilkanDialog();
  }

  void tampilkanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pendaftaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${namaController.text}'),
              const SizedBox(height: 8),
              Text('Email: ${emailController.text}'),
              const SizedBox(height: 8),
              Text('Jenis Kelamin: $jenisKelamin'),
              const SizedBox(height: 8),
              Text('Program Studi: $programStudi'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran berhasil!'),
                  ),
                );
              },
              child: const Text('Daftar'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration dekorasi(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F7),
      appBar: AppBar(
        title: const Text('Pendaftaran Mahasiswa'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.app_registration,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Daftar Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Silakan lengkapi data untuk membuat akun baru.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Nama
              const Text(
                'Data Pribadi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: namaController,
                focusNode: namaFocus,
                textInputAction: TextInputAction.next,
                decoration: dekorasi(
                  'Nama Lengkap',
                  Icons.person_outline,
                ),
                validator: validasiNama,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
              ),

              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: dekorasi(
                  'Alamat Email',
                  Icons.email_outlined,
                ),
                validator: validasiEmail,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocus);
                },
              ),

              const SizedBox(height: 15),

              // Password
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocus,
                obscureText: !passwordVisible,
                textInputAction: TextInputAction.done,
                decoration: dekorasi(
                  'Password',
                  Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                validator: validasiPassword,
                onFieldSubmitted: (_) {
                  daftar();
                },
              ),

              const SizedBox(height: 25),

              // Jenis Kelamin
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          jenisKelamin = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          jenisKelamin = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Program Studi
              const Text(
                'Program Studi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                decoration: dekorasi(
                  'Pilih Program Studi',
                  Icons.school_outlined,
                ),
                initialValue: programStudi,
                items: programStudiList.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    programStudi = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Program studi harus dipilih';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Checkbox
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Saya menyetujui Syarat & Ketentuan',
                  ),
                  value: setuju,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      setuju = value ?? false;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Tombol
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: daftar,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'DAFTAR SEKARANG',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'Pastikan data yang dimasukkan sudah benar.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}