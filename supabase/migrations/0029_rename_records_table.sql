-- =====================================================================
-- Ratechs Swim System — 0029 Rebranding Tabel Rekor
--
-- Rename public.rajendra_records menjadi public.ratechs_records
-- dengan view backward-compatibility untuk menjaga integritas.
-- =====================================================================

do $$
begin
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'rajendra_records'
    and table_type = 'BASE TABLE'
  ) and not exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'ratechs_records'
  ) then
    alter table public.rajendra_records rename to ratechs_records;
    create or replace view public.rajendra_records as select * from public.ratechs_records;
    raise notice 'Renamed public.rajendra_records to public.ratechs_records with view';
  end if;
end $$;
