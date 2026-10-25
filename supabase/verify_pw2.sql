select email,
       (extensions.crypt('Panitia#2026', encrypted_password) = encrypted_password) as panitia_match,
       (extensions.crypt('Penonton#2026', encrypted_password) = encrypted_password) as penonton_match,
       (extensions.crypt('Ratechs#2026', encrypted_password) = encrypted_password) as admin_match
from auth.users
where email in ('panitia@ratechs.id','penonton@ratechs.id','admin@ratechs.id');
