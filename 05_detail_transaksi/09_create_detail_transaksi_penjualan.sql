CREATE TABLE detail_transaksi_penjualan (
    id SERIAL PRIMARY KEY,
    nomor_penjualan VARCHAR(10) REFERENCES transaksi_penjualan(nomor_penjualan),
    urut_item INT,
    kode_produk VARCHAR(10) REFERENCES master_produk(kode),
    qty INT,
    harga NUMERIC(15,2),
    diskon NUMERIC(15,2),
    total_nilai NUMERIC(15,2)
);
