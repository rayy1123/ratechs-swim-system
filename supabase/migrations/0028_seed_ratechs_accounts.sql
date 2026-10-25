-- =====================================================================
-- Ratechs Swim System — 0028 Seeding Akun Resmi Ratechs
--
-- Akun resmi default untuk operasional kejuaraan renang Ratechs:
-- 1. admin@ratechs.id        (super_admin)
-- 2. timer1@ratechs.id       (operator)
-- 3. technical@ratechs.id    (event_admin)
-- 4. finance@ratechs.id      (event_admin)
-- 5. pendaftaran@ratechs.id  (event_admin)
--
-- Password default: Ratechs#2026
-- =====================================================================

do $$
declare
  r record;
  v_user_id uuid;
  v_pass text := 'Ratechs#2026';
  default_users text[][] := array[
    ['admin@ratechs.id', 'Super Admin Ratechs', 'super_admin'],
    ['timer1@ratechs.id', 'Operator Timer Arena 1', 'operator'],
    ['technical@ratechs.id', 'Admin Technical & Wasit', 'event_admin'],
    ['finance@ratechs.id', 'Admin Keuangan & Kasir', 'event_admin'],
    ['pendaftaran@ratechs.id', 'Admin Pendaftaran Kontingen', 'event_admin']
  ];
begin
  create extension if not exists pgcrypto with schema extensions;

  for i in 1..array_length(default_users, 1) loop
    declare
      u_email text := default_users[i][1];
      u_name  text := default_users[i][2];
      u_role  user_role := default_users[i][3]::user_role;
    begin
      select id into v_user_id from auth.users where email = u_email;

      if v_user_id is null then
        v_user_id := gen_random_uuid();

        insert into auth.users (
          instance_id, id, aud, role, email,
          encrypted_password, email_confirmed_at,
          raw_app_meta_data, raw_user_meta_data,
          confirmation_token, recovery_token, email_change,
          email_change_token_new, email_change_token_current,
          phone_change, phone_change_token, reauthentication_token,
          created_at, updated_at
        ) values (
          '00000000-0000-0000-0000-000000000000',
          v_user_id,
          'authenticated',
          'authenticated',
          u_email,
          extensions.crypt(v_pass, extensions.gen_salt('bf')),
          now(),
          '{"provider":"email","providers":["email"]}'::jsonb,
          jsonb_build_object('full_name', u_name, 'role', u_role),
          '', '', '', '', '', '', '', '',
          now(),
          now()
        );

        insert into auth.identities (
          provider_id, user_id, identity_data, provider,
          last_sign_in_at, created_at, updated_at
        ) values (
          v_user_id,
          v_user_id,
          jsonb_build_object(
            'sub', v_user_id::text,
            'email', u_email,
            'email_verified', true
          ),
          'email',
          now(), now(), now()
        );

        raise notice 'Akun Ratechs dibuat: % (%)', u_email, u_role;
      end if;

      insert into public.profiles (id, full_name, role)
      values (v_user_id, u_name, u_role)
      on conflict (id) do update set
        full_name = excluded.full_name,
        role = excluded.role;
    end;
  end loop;
end $$;
