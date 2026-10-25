-- Tes: apakah plaintext cocok dengan hash tersimpan?
select email,
       (crypt('Panitia#2026', encrypted_password) = encrypted_password) as panitia_ok,
       (crypt('Penonton#2026', encrypted_password) = encrypted_password) as penonton_ok,
       (crypt('Ratechs#2026', encrypted_password) = encrypted_password) as admin_ok
from auth.users
where email in ('panitia@ratechs.id','penonton@ratechs.id','admin@ratechs.id');

-- Cek apakah ada kolom 'password' (Supabase versi baru) yang belum terisi
select column_name from information_schema.columns
where table_schema='auth' and table_name='users' and column_name in ('password','encrypted_password');
