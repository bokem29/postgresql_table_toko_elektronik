CREATE TABLE master_harga_jual (
    id SERIAL PRIMARY KEY,
    kode_produk VARCHAR(10) REFERENCES master_product(kode),
    harga NUMERIC(15,2),
    level_pelanggan VARCHAR(20),
    periode_awal DATE,
    periode_akhir DATE
);