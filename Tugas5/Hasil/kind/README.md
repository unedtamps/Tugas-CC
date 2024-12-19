Berikut adalah revisi langkah-langkah tersebut dengan struktur yang lebih jelas dan bahasa yang lebih rapi untuk diikuti:

---

### Langkah Menjalankan Aplikasi

1. **Persiapan Awal**  
   - Masuk ke direktori `bin`:
     ```bash
     cd bin
     ```
   - Jalankan skrip berikut secara berurutan:
     ```bash
     sh download.sh
     source set.sh
     ```

2. **Menjalankan Cluster**  
   - Jalankan skrip untuk memulai cluster:
     ```bash
     sh run.sh
     ```
   - Periksa status cluster hingga semua node siap:
     ```bash
     kubectl get nodes
     ```

3. **Mengatur Ingress**  
   - Masuk ke direktori `ingress` dan jalankan skrip startup:
     ```bash
     cd ingress
     sh startup.sh
     ```
   - Verifikasi apakah Ingress Controller berjalan dengan perintah:
     ```bash
     kubectl get pods -n ingress-nginx
     ```

4. **Menjalankan Aplikasi**  
   - Masuk ke direktori `app` untuk melakukan deployment dan membuat service:
     ```bash
     cd app
     sh run.sh
     ```

5. **Menjalankan Visualisasi**  
   - Masuk ke direktori `visual` dan jalankan skrip berikut:
     ```bash
     cd visual
     sh download.sh
     sh run.sh
     ```
   - Periksa apakah pod berhasil dibuat.

6. **Mengakses Aplikasi**  
   - Dapatkan port dari service Ingress dengan perintah:
     ```bash
     kubectl get service -n ingress-nginx
     ```
   - Akses aplikasi menggunakan format URL berikut:
     ```
     http://<NodeIP>:<Port>
     ```
     (Gantilah `<NodeIP>` dan `<Port>` dengan nilai yang sesuai dari output perintah di atas.)

--- 

Jika ada langkah atau detail yang perlu ditambahkan, beri tahu saya! 😊
