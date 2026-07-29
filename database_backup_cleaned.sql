--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA auth;


-- ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

-- CREATE SCHEMA extensions;


-- ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA graphql;


-- ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA graphql_public;


-- ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

-- CREATE SCHEMA pgbouncer;


-- ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA realtime;


-- ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA storage;


-- ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

-- CREATE SCHEMA vault;


-- ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: Apbdes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Apbdes" (
    id text NOT NULL,
    tahun integer NOT NULL,
    pendapatan double precision NOT NULL,
    belanja double precision NOT NULL,
    kategori_belanja jsonb NOT NULL,
    lebih_kurang double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public."Apbdes" OWNER TO postgres;

--
-- Name: Document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Document" (
    id text NOT NULL,
    judul text NOT NULL,
    file_url text NOT NULL,
    size text,
    format text,
    published_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    category_id text NOT NULL
);


ALTER TABLE public."Document" OWNER TO postgres;

--
-- Name: DocumentCategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DocumentCategory" (
    id text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public."DocumentCategory" OWNER TO postgres;

--
-- Name: Galeri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Galeri" (
    id text NOT NULL,
    foto_url text NOT NULL,
    caption text NOT NULL,
    katalog_id text,
    kegiatan_id text
);


ALTER TABLE public."Galeri" OWNER TO postgres;

--
-- Name: IdmSdgScore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."IdmSdgScore" (
    id text NOT NULL,
    tahun integer NOT NULL,
    skor_idm double precision NOT NULL,
    status_idm text NOT NULL,
    skor_sdgs double precision NOT NULL
);


ALTER TABLE public."IdmSdgScore" OWNER TO postgres;

--
-- Name: Katalog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Katalog" (
    id text NOT NULL,
    nama text NOT NULL,
    slug text NOT NULL,
    deskripsi text NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    dusun text,
    kontak text,
    "fotoUrl" text,
    "categoryId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Katalog" OWNER TO postgres;

--
-- Name: KatalogCategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."KatalogCategory" (
    id text NOT NULL,
    nama text NOT NULL,
    icon text
);


ALTER TABLE public."KatalogCategory" OWNER TO postgres;

--
-- Name: Kegiatan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kegiatan" (
    id text NOT NULL,
    judul text NOT NULL,
    deskripsi text NOT NULL,
    tanggal text NOT NULL,
    lokasi text NOT NULL
);


ALTER TABLE public."Kegiatan" OWNER TO postgres;

--
-- Name: News; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."News" (
    id text NOT NULL,
    judul text NOT NULL,
    slug text NOT NULL,
    konten text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    tanggal_publikasi timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cover_url text,
    penulis_id text NOT NULL
);


ALTER TABLE public."News" OWNER TO postgres;

--
-- Name: PendudukStat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PendudukStat" (
    id text NOT NULL,
    tahun integer NOT NULL,
    total_penduduk integer NOT NULL,
    laki_laki integer NOT NULL,
    perempuan integer NOT NULL,
    jumlah_kk integer NOT NULL
);


ALTER TABLE public."PendudukStat" OWNER TO postgres;

--
-- Name: Pengaduan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pengaduan" (
    id text NOT NULL,
    nama_pelapor text NOT NULL,
    kontak text NOT NULL,
    judul text NOT NULL,
    deskripsi text NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Pengaduan" OWNER TO postgres;

--
-- Name: StrukturOrganisasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StrukturOrganisasi" (
    id text NOT NULL,
    jabatan text NOT NULL,
    nama_pejabat text NOT NULL,
    urutan integer DEFAULT 0 NOT NULL,
    foto_url text
);


ALTER TABLE public."StrukturOrganisasi" OWNER TO postgres;

--
-- Name: StuntingBansos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StuntingBansos" (
    id text NOT NULL,
    tahun integer NOT NULL,
    jumlah_stunting integer NOT NULL,
    penerima_bansos integer NOT NULL
);


ALTER TABLE public."StuntingBansos" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    nama text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role text DEFAULT 'EDITOR'::text NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: VillageProfile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VillageProfile" (
    id text NOT NULL,
    sejarah text NOT NULL,
    misi text[],
    sambutan_kepdes text NOT NULL,
    peta_url text,
    koordinat text,
    batas_desa text,
    luas_wilayah text,
    jumlah_penduduk integer,
    realisasi_dana_desa_persen integer DEFAULT 0 NOT NULL,
    umkm_aktif integer DEFAULT 0 NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    visi text[]
);


ALTER TABLE public."VillageProfile" OWNER TO postgres;

--
-- Data for Name: Apbdes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Apbdes" (id, tahun, pendapatan, belanja, kategori_belanja, lebih_kurang) VALUES
('92504f9b-264c-4051-bd11-0cd57f928daf', '2026', '2011179180', '1846985636', '[{"nama": "Penyelenggaraan Pemerintahan", "jumlah": 450000000}, {"nama": "Pelaksanaan Pembangunan", "jumlah": 700000000}, {"nama": "Pembinaan Kemasyarakatan", "jumlah": 150000000}, {"nama": "Pemberdayaan Masyarakat", "jumlah": 150000000}]', '456667');


--
-- Data for Name: Document; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for this table


--
-- Data for Name: DocumentCategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."DocumentCategory" (id, name) VALUES
('21e099da-cdb4-4dc0-b62b-df83e8b89c28', 'RPJMDes'),
('5782f397-9671-4324-90db-ef470e7249a0', 'APBDes'),
('eab62a5b-e7f1-4052-8af5-5018c29dfe55', 'Peraturan Desa'),
('8d3e3719-a3bb-46fa-bb31-40918b3f5ffd', 'LKPJ');


--
-- Data for Name: Galeri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Galeri" (id, foto_url, caption, katalog_id, kegiatan_id) VALUES
('8270f980-4945-4b2c-b64c-8c081b9d052d', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=800&auto=format&fit=crop', 'Pemandangan sawah Desa Suka Makmur saat pagi hari', NULL, NULL),
('e309cf85-939a-4c78-9ad2-8d0039c8d29f', 'https://images.unsplash.com/photo-1542385151-efd9000785a0?q=80&w=800&auto=format&fit=crop', 'Kegiatan posyandu lansia bulan Maret 2026', NULL, NULL),
('a67e03c5-72df-4f9a-a003-db1c8c0397c4', 'https://images.unsplash.com/photo-1523730205978-59fd1b2965e3?q=80&w=800&auto=format&fit=crop', 'Produk unggulan UMKM Anyaman Bambu', NULL, NULL),
('ad394f4f-f8ef-4edd-b37f-b968e8374cad', 'https://images.unsplash.com/photo-1577495508048-b635879837f1?q=80&w=800&auto=format&fit=crop', 'Musrenbangdes 2026', NULL, NULL),
('ec7b89e8-78c4-4771-a653-1da339b4917a', 'https://images.unsplash.com/photo-1509099880697-8c1b20dba559?q=80&w=800&auto=format&fit=crop', 'Gotong royong bersih irigasi', NULL, NULL),
('8b9c52d9-a57e-4bea-b9b3-246b9a1977be', 'https://images.unsplash.com/photo-1593526613712-7b4b9a707330?q=80&w=800&auto=format&fit=crop', 'Posyandu Balita predikat Mandiri', NULL, NULL);


--
-- Data for Name: IdmSdgScore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."IdmSdgScore" (id, tahun, skor_idm, status_idm, skor_sdgs) VALUES
('f5a8dfbd-af0f-4087-bb4d-c59a063c38d1', '2026', '0.825', 'Maju', '78.5');


--
-- Data for Name: Katalog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Katalog" (id, nama, slug, deskripsi, latitude, longitude, dusun, kontak, "fotoUrl", "categoryId", "createdAt") VALUES
('8f6d26f0-8675-4cbf-9160-1d6a47576022', 'Kopi bogak', 'kopi-bogak', '<p><img src="https://placehold.co/600x400?text=Kopi+Bogak"></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">Kopi&nbsp;Bogak&nbsp;adalah&nbsp;tempat&nbsp;nongkrong&nbsp;ngopi&nbsp;yang&nbsp;biasanya&nbsp;ditempati&nbsp;anak&nbsp;muda&nbsp;setempat.&nbsp;Bogak&nbsp;terletak&nbsp;di&nbsp;dusun&nbsp;5&nbsp;dan&nbsp;buka&nbsp;di&nbsp;hari&nbsp;selasa&nbsp;-&nbsp;sabtu&nbsp;di&nbsp;jam&nbsp;11.00&nbsp;-&nbsp;23.00,&nbsp;dan&nbsp;di&nbsp;hari&nbsp;minggu/libur&nbsp;tutup&nbsp;di&nbsp;jam&nbsp;00.00.</span></p>', '3.513435926499388', '98.68160224504106', 'Dusun V', '0812-6020-7482', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722123701-2ac70c4b.avif', '017172fc-f061-4a5e-beec-21d4120b746f', '2026-07-22 12:10:12.124'),
('8e362203-10d6-4a50-84b8-b70828e2b5ab', 'PT. Bacco Makmur Jaya', 'pt-bacco-makmur-jaya', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">toko&nbsp;ahli&nbsp;tembakau.&nbsp;grosir&nbsp;dan&nbsp;eceran&nbsp;tembakau&nbsp;berkualitas&nbsp;dengan&nbsp;harga&nbsp;bersaing.&nbsp;</span></p>', '3.515134475902039', '98.6841544286714', '', '081263636621', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722371668-6206988b.jpg', '90a55760-fa48-485a-a114-7b3f489c4e5d', '2026-07-22 12:13:04.357'),
('a7102675-d0c5-4e29-bafb-a3547c88aa20', 'Toko Alat Jahit Vivi', 'toko-alat-jahit-vivi', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">tempat&nbsp;jualan&nbsp;alat&nbsp;jahit,&nbsp;jasa&nbsp;jahit,&nbsp;tempahan&nbsp;khusus</span></p><p><img src="https://placehold.co/600x400?text=Kopi+Bogak"></p>', '3.514373682896323', '98.68026878438793', '', '081361385719', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722459380-2cfa9cdb.avif', '1954e864-6258-4813-95e1-e518eb78ed1b', '2026-07-22 12:14:42.164'),
('c87a5b0d-469a-4553-90c7-f44f3ee2cd30', 'Toko bloomshe', 'toko-bloomshe', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">toko&nbsp;skincare,&nbsp;hair&nbsp;care,&nbsp;body&nbsp;care&nbsp;dan&nbsp;aksesoris&nbsp;wanita.&nbsp;buka&nbsp;dari&nbsp;senin&nbsp;hingga&nbsp;sabtu&nbsp;dari&nbsp;08.25-17.30.</span></p>', '3.517234434079445', '98.68221339783362', '', '', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722529904-8e6d9bdc.avif', '1954e864-6258-4813-95e1-e518eb78ed1b', '2026-07-22 12:15:46.1'),
('375d8780-21f4-4e08-941f-1e0a89d3325f', 'Angkringan Pakde', 'angkringan-pakde', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">tempat&nbsp;nongkrong&nbsp;nyaman.&nbsp;makan&nbsp;dan&nbsp;minuman&nbsp;enak&nbsp;dan&nbsp;ramah&nbsp;di&nbsp;kantong.</span></p><p><img src="https://placehold.co/600x400?text=Kopi+Bogak"></p>', '3.515174253758328', '98.68193371150603', '', '082162109335', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722607357-3a85aa9c.avif', '017172fc-f061-4a5e-beec-21d4120b746f', '2026-07-22 12:17:17.129'),
('4e7a5ad0-a2b3-46de-ba1b-14a5f93a17c9', 'SIOMAY PAK KOS', 'siomay-pak-kos', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">tempat&nbsp;jualan&nbsp;siomay,&nbsp;bakso,&nbsp;dan&nbsp;mie&nbsp;ayam&nbsp;enak&nbsp;dan&nbsp;harga&nbsp;bersaing.&nbsp;</span></p><p><img src="https://placehold.co/600x400?text=Kopi+Bogak"></p>', '3.514916144085866', '98.68304384441736', '', '', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784722683166-ce67efe3.avif', '90a55760-fa48-485a-a114-7b3f489c4e5d', '2026-07-22 12:18:30.232'),
('d6159811-7165-4621-9920-5b4570341fad', 'BUMDes Mas Lele', 'bumdes-mas-lele', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">Badan&nbsp;Usaha&nbsp;Milik&nbsp;Desa&nbsp;yang&nbsp;berkecimpung&nbsp;dalam&nbsp;pemberdayaan&nbsp;ikan&nbsp;lele.</span></p><p></p><p><img src="https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723231051-9d9a1a0b.avif"></p>', '3.513366681233681', '98.6818164852321', '', '', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723188588-bd39b72a.avif', '017172fc-f061-4a5e-beec-21d4120b746f', '2026-07-22 12:27:18.954'),
('222ac8fb-2903-4281-a013-d5785cdb2b66', 'RIZKY SABLON CUP PLASTIK', 'rizky-sablon-cup-plastik', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">jasa&nbsp;produk&nbsp;sablon&nbsp;cup&nbsp;plastik&nbsp;murah&nbsp;berkualitas,&nbsp;hasil&nbsp;sablon&nbsp;bagus&nbsp;dan&nbsp;rapi.</span></p><p><img src="https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723298310-f6b4abb7.avif"></p>', '3.514185946456479', '98.68526872506052', '', '082166797985', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723298218-82e612f1.avif', '1954e864-6258-4813-95e1-e518eb78ed1b', '2026-07-22 12:28:23.509'),
('892b9b82-06d4-4757-ba32-a29de7a24203', 'Bakso Mas Pendek', 'bakso-mas-pendek', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">tempat&nbsp;makan&nbsp;bakso,&nbsp;mie&nbsp;ayam.&nbsp;suwiran&nbsp;ayamnya&nbsp;besar,&nbsp;kuahnya&nbsp;gurih,&nbsp;porsinya&nbsp;banyak.&nbsp;buka&nbsp;setiap&nbsp;hari&nbsp;dari&nbsp;jam&nbsp;11.00-23.00.</span></p><p><img src="https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723399718-06cab652.avif"></p>', '3.517625083662299', '98.68604444232871', '', '087893169537', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723399721-379bbb1c.avif', '90a55760-fa48-485a-a114-7b3f489c4e5d', '2026-07-22 12:30:10.666'),
('0563ea96-c3a4-4d0f-bbea-49fe357d95d4', 'Angga Kusen', 'angga-kusen', '<p><span style="background-color: rgb(255, 255, 255); color: rgb(31, 31, 31);">toko&nbsp;kayu.&nbsp;harga&nbsp;terjangkau,&nbsp;kualitas&nbsp;bagus,&nbsp;pelayanan&nbsp;ramah.</span></p><p><img src="https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723464730-1e9bf462.avif"></p>', '3.514973588488547', '98.68595642736913', '', '082282548070', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784723452874-2a7a45ee.avif', '1954e864-6258-4813-95e1-e518eb78ed1b', '2026-07-22 12:31:12.765');


--
-- Data for Name: KatalogCategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."KatalogCategory" (id, nama, icon) VALUES
('017172fc-f061-4a5e-beec-21d4120b746f', 'UMKM', 'Store'),
('ef82e854-1395-4963-9272-7927c0ff4897', 'Wisata', 'MapPin'),
('90a55760-fa48-485a-a114-7b3f489c4e5d', 'Kuliner', 'Utensils'),
('1954e864-6258-4813-95e1-e518eb78ed1b', 'Kerajinan', 'Brush');


--
-- Data for Name: Kegiatan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Kegiatan" (id, judul, deskripsi, tanggal, lokasi) VALUES
('e9c635f3-936b-405d-b8f2-54b81ec56762', 'Lomba Desa Sehat', 'Kegiatan lomba kebersihan antar RT se-Desa Suka Makmur.', '2026-08-10', 'Balai Desa Suka Makmur'),
('34d7c7bf-93c0-49ff-8034-94935711355d', 'Pelatihan Digital Marketing UMKM', 'Pelatihan pemasaran produk UMKM secara digital menggunakan media sosial dan marketplace.', '2026-08-25', 'Aula Desa Suka Makmur'),
('2a29c8fa-0c48-4241-849a-db3d04685d7f', 'HUT Kemerdekaan RI ke-81', 'Peringatan Hari Ulang Tahun Kemerdekaan Republik Indonesia ke-81 dengan berbagai perlombaan dan pertunjukan seni.', '2026-08-17', 'Lapangan Desa Suka Makmur');


--
-- Data for Name: News; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for this table


--
-- Data for Name: PendudukStat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PendudukStat" (id, tahun, total_penduduk, laki_laki, perempuan, jumlah_kk) VALUES
('6302874e-b2f5-481c-88e5-06e75d11e24f', '2026', '11205', '5249', '5956', '0');


--
-- Data for Name: Pengaduan; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for this table


--
-- Data for Name: StrukturOrganisasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."StrukturOrganisasi" (id, jabatan, nama_pejabat, urutan, foto_url) VALUES
('938750f8-d04e-42bc-9350-ad8632db2b98', 'Bendahara', 'Ardina Syahfitri Nst', '3', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724352784-e87b7ca9.jpeg'),
('e48445c4-f691-479d-aab8-d8129050ceb1', 'Kaur Umum', 'Aqila Ayu Anas', '4', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724381168-bb837000.jpeg'),
('f209c902-5c04-420f-9c51-ef444d88fb26', 'Kasi Pelayanan', 'Irma Wati', '5', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724410952-aeb9f3ec.jpeg'),
('de041e16-6157-40b1-bb03-5bf161e498ae', 'Kasi Pemerintahan', 'Annisa Berkah', '0', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724267659-bd1f822b.jpeg'),
('20e410dd-a442-4c4a-84a3-cfdedaca85f5', 'Kaur Perencanaan', 'Andika Herdietya', '6', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724438056-64cc0927.jpeg'),
('33597f2d-fbae-47ae-a839-d04b2413c4a9', 'Plt. Sekretaris', 'Supri Yanto', '2', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724306699-df5c5e73.jpeg'),
('857481b5-82d3-464b-a2d7-4960000fa169', 'Kepala Desa', 'Syahriel, S.Sos.', '1', 'https://etovj8as0tcltt3d.public.blob.vercel-storage.com/uploads/1784724195022-ba982e09.jpeg');


--
-- Data for Name: StuntingBansos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."StuntingBansos" (id, tahun, jumlah_stunting, penerima_bansos) VALUES
('e8210219-a215-4a80-b4de-d8a5d65373aa', '2026', '12', '145');


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."User" (id, nama, email, password, role) VALUES
('63b81825-98ae-4cde-a2df-02045bd5056e', 'Editor Desa', 'editor@sukamakmur.desa.id', '$2b$10$WQPqkJ1KAiH2LeEj6NWJKuqQgUys/1zPNvn4/jz4VKwq49JX339ay', 'EDITOR'),
('73396b00-9edb-4dfc-bb77-f7395f68597d', 'Admin Desa', 'admin@sukamakmur.desa.id', '$2b$10$Ra80Gu8Tu9Rm0GnNZ6Qxruw6we789TRKM/4494xBXzFprPs5QNhFG', 'ADMIN');


--
-- Data for Name: VillageProfile; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."VillageProfile" (id, sejarah, misi, sambutan_kepdes, peta_url, koordinat, batas_desa, luas_wilayah, jumlah_penduduk, realisasi_dana_desa_persen, umkm_aktif, "updatedAt", visi) VALUES
('2cba7efd-0a2f-4e5b-b50c-c9a7bf87924a', '<p>Berawalan&nbsp;dari&nbsp;Desa&nbsp;Pemekaran&nbsp;yaitu&nbsp;dari&nbsp;Desa&nbsp;Induk&nbsp;Desa&nbsp;Kedai&nbsp;Durian&nbsp;Kecamatan&nbsp;Delitua&nbsp;tahun&nbsp;1994,&nbsp;Kemudian&nbsp;menjadi&nbsp;Desa&nbsp;Definitif&nbsp;pada&nbsp;tahun&nbsp;1996,&nbsp;yang&nbsp;disahkan&nbsp;oleh&nbsp;Dirgen&nbsp;Kur&nbsp;Out&nbsp;(Pengembangan&nbsp;Urusan&nbsp;Otonomi&nbsp;Daeah).&nbsp;</p><p></p><p>Daerah&nbsp;kecamatan&nbsp;Deli&nbsp;Tua&nbsp;dikenal&nbsp;sejak&nbsp;abad&nbsp;16&nbsp;M&nbsp;dan&nbsp;menjadi&nbsp;bagian&nbsp;dari&nbsp;kesultanan&nbsp;Aceh,&nbsp;dan&nbsp;pada&nbsp;abad&nbsp;19&nbsp;daerah&nbsp;ini&nbsp;menjadi&nbsp;bagian&nbsp;dari&nbsp;Kesultanan&nbsp;Deli.&nbsp;Kawasan&nbsp;Kecamatan&nbsp;ini&nbsp;dikenal&nbsp;juga&nbsp;sebagai&nbsp;daerah&nbsp;perkebunan&nbsp;Tembakau&nbsp;Deli&nbsp;atau&nbsp;Deli&nbsp;Mascal.&nbsp;Pada&nbsp;masa&nbsp;penjajahan&nbsp;Belanda,&nbsp;daerah&nbsp;Deli&nbsp;Tua&nbsp;termasuk&nbsp;dalam&nbsp;wilayah&nbsp;Kewedanan&nbsp;Deli&nbsp;Hulu.&nbsp;Setelah&nbsp;kemerdekaan&nbsp;Indonesia&nbsp;tanggal&nbsp;17&nbsp;Agustus&nbsp;1945,&nbsp;daerah&nbsp;ini&nbsp;di&nbsp;bentuk&nbsp;menjadi&nbsp;satu&nbsp;Kecamatan&nbsp;nya&nbsp;itu&nbsp;Kecamatan&nbsp;Deli&nbsp;Tua&nbsp;dengan&nbsp;jumlah&nbsp;desa&nbsp;sebanyak&nbsp;8&nbsp;desa&nbsp;dengan&nbsp;pusat&nbsp;Pemerintahan&nbsp;berada&nbsp;di&nbsp;Desa&nbsp;Suka&nbsp;Maju&nbsp;(Sekarang&nbsp;Kampung&nbsp;Baru).</p><p></p><p>Pada&nbsp;tahun&nbsp;1974,&nbsp;sebagian&nbsp;kawasan&nbsp;kecamatan&nbsp;ini&nbsp;menjadi&nbsp;wilayah&nbsp;administratif&nbsp;kota&nbsp;Medan,&nbsp;sehingga&nbsp;kecamatan&nbsp;Deli&nbsp;Tua&nbsp;menjadi&nbsp;2&nbsp;Desa/Kelurahan&nbsp;dengan&nbsp;pusat&nbsp;pemerintahan&nbsp;di&nbsp;kelurahan&nbsp;Deli&nbsp;Tua.&nbsp;Daerah&nbsp;kecamatan&nbsp;Deli&nbsp;Tua&nbsp;kembali&nbsp;di&nbsp;mekarkan&nbsp;menjadi&nbsp;3&nbsp;Desa&nbsp;dan&nbsp;3&nbsp;Kelurahan&nbsp;dan&nbsp;pusat&nbsp;pemerintahan&nbsp;terletak&nbsp;di&nbsp;Deli&nbsp;Tua&nbsp;Timur.</p>', '{"Menciptakan Desa Suka Makmur Sejahtera, dan Aman.","Menciptakan Masyarakat yang Sejahtera.","Menciptakan Masyarakat Desa Suka Makmur Aman, Tertib, dan Religius."}', 'Selamat datang di portal resmi Desa Suka Makmur. Melalui website ini, kami berkomitmen mewujudkan tata kelola desa yang transparan, inovatif, dan responsif. Kami berharap sistem informasi ini dapat mendekatkan pelayanan kepada masyarakat dan membuka potensi desa ke kancah yang lebih luas.', '', '-6.200000, 106.816666', 'Utara: Desa Beringin Jaya, Selatan: Sungai Makmur, Timur: Hutan Lindung, Barat: Kecamatan Beringin.', '161 Hektar', '11205', '96', '10', '2026-07-28 10:15:09.588', '{"Menciptakan Desa Suka Makmur transaran dan menjadi Desa yang Maju.","Menciptakan Masyarakat yang Sejahtera.","Menciptakan Masyarakat Desa Suka Makmur Aman, Tertib dan Religius."}');


--
-- Name: Apbdes Apbdes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Apbdes"
    ADD CONSTRAINT "Apbdes_pkey" PRIMARY KEY (id);


--
-- Name: DocumentCategory DocumentCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DocumentCategory"
    ADD CONSTRAINT "DocumentCategory_pkey" PRIMARY KEY (id);


--
-- Name: Document Document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_pkey" PRIMARY KEY (id);


--
-- Name: Galeri Galeri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Galeri"
    ADD CONSTRAINT "Galeri_pkey" PRIMARY KEY (id);


--
-- Name: IdmSdgScore IdmSdgScore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."IdmSdgScore"
    ADD CONSTRAINT "IdmSdgScore_pkey" PRIMARY KEY (id);


--
-- Name: KatalogCategory KatalogCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."KatalogCategory"
    ADD CONSTRAINT "KatalogCategory_pkey" PRIMARY KEY (id);


--
-- Name: Katalog Katalog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Katalog"
    ADD CONSTRAINT "Katalog_pkey" PRIMARY KEY (id);


--
-- Name: Kegiatan Kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kegiatan"
    ADD CONSTRAINT "Kegiatan_pkey" PRIMARY KEY (id);


--
-- Name: News News_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."News"
    ADD CONSTRAINT "News_pkey" PRIMARY KEY (id);


--
-- Name: PendudukStat PendudukStat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PendudukStat"
    ADD CONSTRAINT "PendudukStat_pkey" PRIMARY KEY (id);


--
-- Name: Pengaduan Pengaduan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pengaduan"
    ADD CONSTRAINT "Pengaduan_pkey" PRIMARY KEY (id);


--
-- Name: StrukturOrganisasi StrukturOrganisasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StrukturOrganisasi"
    ADD CONSTRAINT "StrukturOrganisasi_pkey" PRIMARY KEY (id);


--
-- Name: StuntingBansos StuntingBansos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StuntingBansos"
    ADD CONSTRAINT "StuntingBansos_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: VillageProfile VillageProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VillageProfile"
    ADD CONSTRAINT "VillageProfile_pkey" PRIMARY KEY (id);


--
-- Name: Apbdes_tahun_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Apbdes_tahun_key" ON public."Apbdes" USING btree (tahun);


--
-- Name: IdmSdgScore_tahun_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IdmSdgScore_tahun_key" ON public."IdmSdgScore" USING btree (tahun);


--
-- Name: Katalog_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Katalog_slug_key" ON public."Katalog" USING btree (slug);


--
-- Name: News_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "News_slug_key" ON public."News" USING btree (slug);


--
-- Name: PendudukStat_tahun_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "PendudukStat_tahun_key" ON public."PendudukStat" USING btree (tahun);


--
-- Name: StuntingBansos_tahun_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "StuntingBansos_tahun_key" ON public."StuntingBansos" USING btree (tahun);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Document Document_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public."DocumentCategory"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Katalog Katalog_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Katalog"
    ADD CONSTRAINT "Katalog_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."KatalogCategory"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: News News_penulis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."News"
    ADD CONSTRAINT "News_penulis_id_fkey" FOREIGN KEY (penulis_id) REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;

