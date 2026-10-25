-- Hapus akun setengah-jadi (state rusak dari insert manual)
delete from auth.identities where user_id in (
  select id from auth.users where email in ('panitia@ratechs.id','penonton@ratechs.id'));
delete from public.profiles where id in (
  select id from auth.users where email in ('panitia@ratechs.id','penonton@ratechs.id'));
delete from auth.users where email in ('panitia@ratechs.id','penonton@ratechs.id');

select count(*) as remaining from auth.users where email in ('panitia@ratechs.id','penonton@ratechs.id');
