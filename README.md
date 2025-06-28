Judul Proyek : DiaryApp

Deskripsi Aplikasi : catatan atau diary interaktif berbasis Flutter. 
Pengguna dapat menulis, menggambar, dan menyisipkan gambar dalam satu kanvas. 
Data disimpan secara cloud melalui Firebase dan dapat dimuat kembali berdasarkan akun login. (NB : fitur muat kembali berdasarkan akun login gagal diimplementasikan)

Daftar Anggota Kelompok : 
- Shefanny - [221110383]
- Charlie William Wijaya - [221110844]
- Gilbert Garvin Wijaya - [221111169]
- Nicholas Tio - [221111917]
- Bryan Yapiter - [221110930]

Teknologi yang Digunakan : 
- Frontend menggunakan Flutter
- Backend menggunakan Firebase Auth dan Cloud Firestore
- Platform cloud menggunakan Firebase dari Google Cloud Platform

Fitur Aplikasi
- Login dan register pengguna
- Menambahkan judul catatan
- Drag dan manipulasi elemen teks atau gambar di dalam kanvas
- Simpan catatan ke Firestore, termasuk elemen-elemen di dalamnya (gagal diimplementasikan)
- Menampilkan daftar catatan sesuai user login (gagal diimplementasikan)
- Menampilkan dan memuat ulang isi catatan untuk diedit kembali (gagal diimplementasikan)
- Arsitektur Cloud Aplikasi Flutter terhubung langsung ke Firebase
- Autentikasi pengguna disimpan di Firebase
- Auth Data catatan disimpan di Firestore dengan field userId Query dijalankan berdasarkan userId dan urutan waktu pembuatan catatan (berhasil disimpan, namun gagal ditampilkan kembali)

Link Aplikasi Live : https://diary-9c897.web.app/ (gagal deploy, hanya muncul layar putih blank)

Video Demonstrasi : https://mikroskilacid-my.sharepoint.com/:v:/g/personal/221110383_students_mikroskil_ac_id/EQ0FjEHuEu9Eh3cl_aV_tVcBlDqVBGG1VRYEmT5qCQJxmA?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=gNxkbw


Cara Menjalankan Proyek
- Clone repository ini
- Masuk ke folder frontend
- Jalankan perintah flutter pub get
- Pastikan file google-services.json ada di android/app
- Aktifkan Authentication dan Firestore di Firebase Console
- Jalankan emulator atau sambungkan perangkat
- Jalankan perintah flutter run

Petunjuk Penggunaan Aplikasi
- Register atau login dengan email
- Buat catatan baru dan beri judul
- Tambahkan teks atau gambar ke dalam canvas
- Simpan catatan (catatan berhasil disimpan ke firestore, namun gagal ditampilkan kembali)
- Lihat kembali daftar catatan dari halaman utama (gagal diimplementasikan)
- Edit catatan yang tersimpan (gagal diimplementasikan)

