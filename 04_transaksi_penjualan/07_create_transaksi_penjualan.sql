CREATE TABLE transaksi_penjualan (
    nomor_penjualan VARCHAR(10) PRIMARY KEY,
    tanggal DATE,
    customer VARCHAR(10) REFERENCES master_pelanggan(kode),
    nama_kasir VARCHAR(50),
    status_penjualan VARCHAR(10) DEFAULT 'DONE'
);
