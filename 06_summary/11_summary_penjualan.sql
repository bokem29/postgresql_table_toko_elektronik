-- ===========================================
-- 1. Daftar Customer yang Tidak Berbelanja
-- Rentang Tanggal: 2024-01-15 sampai 2024-01-25
-- ===========================================
SELECT p.kode, p.nama, p.level_pelanggan, p.asal_kota
FROM master_pelanggan p
WHERE p.kode NOT IN (
    SELECT t.customer
    FROM transaksi_penjualan t
    WHERE t.tanggal BETWEEN '2024-01-15' AND '2024-01-25'
);

-- ===========================================
-- 2. Summary Quantity Penjualan per Brand
-- ===========================================
SELECT mp.brand, SUM(dtp.qty) AS total_qty
FROM detail_transaksi dtp
JOIN master_produk mp ON dtp.kode_produk = mp.kode_produk
JOIN transaksi_penjualan tp ON dtp.nomor_penjualan = tp.nomor_penjualan
GROUP BY mp.brand
ORDER BY total_qty DESC;

-- ===========================================
-- 3. Tambahkan Kolom status_penjualan pada Transaksi Penjualan
-- ===========================================
ALTER TABLE transaksi_penjualan
ADD COLUMN IF NOT EXISTS status_penjualan VARCHAR(10) DEFAULT 'DONE';

-- ===========================================
-- 4. Update status_penjualan secara random
-- ===========================================
UPDATE transaksi_penjualan
SET status_penjualan = CASE
    WHEN random() < 0.5 THEN 'CANCEL'
    ELSE 'DONE'
END;

-- ===========================================
-- 5. Cek Status Penjualan
-- ===========================================
SELECT nomor_penjualan, status_penjualan
FROM transaksi_penjualan;
