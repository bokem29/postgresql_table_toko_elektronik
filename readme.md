# 📦 Projek Basis Data Toko Elektronik

Projek ini berisi script SQL untuk pembuatan database, tabel master, transaksi, serta query summary penjualan.  
Database menggunakan **PostgreSQL** dan query diuji menggunakan **pgAdmin / dBeaver** 

---
## 📂 Struktur Folder

```bash
├── 00_database.sql
├── 01_master_produk/
│ ├── 01_create_master_produk.sql
│ └── 02_insert_master_produk.sql
├── 02_master_harga_jual/
│ ├── 03_create_master_harga_jual.sql
│ └── 04_insert_master_harga_jual.sql
├── 03_master_pelanggan/
│ ├── 05_create_master_pelanggan.sql
│ └── 06_insert_master_pelanggan.sql
├── 04_transaksi_penjualan/
│ ├── 07_create_transaksi_penjualan.sql
│ └── 08_insert_transaksi_penjualan.sql
├── 05_detail_transaksi/
│ ├── 09_create_detail_transaksi.sql
│ └── 10_insert_detail_transaksi.sql
└── 06_summary/
└── 11_summary_penjualan.sql
```
---
## 🚀 Cara Menjalankan

### 1. Menggunakan psql console

```bash
# Import database
psql -U postgres -d toko_elektronik -f 00_database.sql

# Eksekusi tabel master & transaksi
psql -U postgres -d toko_elektronik -f 01_master_produk/01_create_master_produk.sql
psql -U postgres -d toko_elektronik -f 01_master_produk/02_insert_master_produk.sql
...
psql -U postgres -d toko_elektronik -f 06_summary/11_summary_penjualan.sql
```

### 2. Menggunakan DBeaver

1. Buka DBeaver dan buat koneksi baru ke PostgreSQL.

    - Host: `localhost`

    - Port: `5432`

    - Database: `toko_elektronik` 

    - User: `postgres`

    - Password: sesuai konfigurasi

2. Klik kanan pada database → `Tools` → `Execute Script`.

3. Pilih file SQL yang ingin dijalankan, misalnya `00_database.sql`.

4. Jalankan dengan shortcut:

    - `Ctrl + Enter` → untuk mengeksekusi query yang dipilih.

    - `Alt + X` → untuk mengeksekusi semua query di file.

5. Ulangi langkah ini untuk semua `file create_*.sql` dan `insert_*.sql`.

6. Terakhir, jalankan file `11_summary_penjualan.sql` untuk menampilkan hasil summary.

---

## 📑 Soal & Query

### 1. Daftar Customer yang Tidak Berbelanja pada Rentang Tanggal Tertentu

```sql
SELECT p.kode, p.nama, p.level_pelanggan, p.asal_kota
FROM master_pelanggan p
WHERE p.kode NOT IN (
    SELECT t.customer
    FROM transaksi_penjualan t
    WHERE t.tanggal BETWEEN '2024-01-15' AND '2024-01-25'
);
```

### 2. Summary Quantity Penjualan per Brand

```sql
SELECT mp.brand, SUM(dtp.qty) AS total_qty
FROM detail_transaksi_penjualan dtp
JOIN master_product mp ON dtp.kode_produk = mp.kode
JOIN transaksi_penjualan tp ON dtp.nomor_penjualan = tp.nomor_penjualan
GROUP BY mp.brand
ORDER BY total_qty DESC;
```

### 3. Tambahkan Kolom Status Penjualan & Update Transaksi Random CANCEL DONE

```sql
ALTER TABLE transaksi_penjualan
ADD COLUMN status_penjualan VARCHAR(10) DEFAULT 'DONE';

UPDATE transaksi_penjualan
SET status_penjualan = CASE
    WHEN random() < 0.5 THEN 'CANCEL'
    ELSE 'DONE'
END;
```

### 4. Cek Status Penjualan

```sql
SELECT nomor_penjualan, status_penjualan
FROM transaksi_penjualan;
```

---

## ⚠️ Catatan Penting

- Jalankan file `00_database.sql` terlebih dahulu sebelum menjalankan script lainnya.

- Jika kolom `status_penjualan` sudah pernah ditambahkan, maka eksekusi ulang ALTER TABLE akan menimbulkan error. Solusinya: hapus kolom dengan

```sql
ALTER TABLE transaksi_penjualan DROP COLUMN status_penjualan;
```

atau dengan cara menambahkan `IF NOT EXISTS` pada

```sql
ALTER TABLE transaksi_penjualan
ADD COLUMN IF NOT EXISTS status_penjualan VARCHAR(10) DEFAULT 'DONE';
```

- Pastikan urutan eksekusi `create` dilakukan sebelum `insert`.

- Gunakan `ROLLBACK` atau `TRUNCATE` jika ingin mengulang dari awal.