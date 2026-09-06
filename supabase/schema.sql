create extension if not exists "pgcrypto";
create type public.user_role as enum ('adoptante','refugio');
create type public.pet_status as enum ('disponible','en_proceso','adoptado');
create type public.application_status as enum ('pendiente','aprobada','rechazada');

create table public.profiles(id uuid primary key references auth.users(id) on delete cascade,full_name text not null,role user_role not null default 'adoptante',city text,created_at timestamptz not null default now());
create table public.pets(id uuid primary key default gen_random_uuid(),owner_id uuid not null references public.profiles(id) on delete cascade,name text not null,species text not null check(species in ('perro','gato')),breed text not null,age int not null check(age between 0 and 30),city text not null,description text not null,image_url text not null,status pet_status not null default 'disponible',created_at timestamptz not null default now());
create table public.applications(id uuid primary key default gen_random_uuid(),pet_id uuid not null references public.pets(id) on delete cascade,applicant_id uuid not null references public.profiles(id) on delete cascade,message text not null,status application_status not null default 'pendiente',created_at timestamptz not null default now(),unique(pet_id,applicant_id));

alter table public.profiles enable row level security;alter table public.pets enable row level security;alter table public.applications enable row level security;
create policy "profiles public read" on public.profiles for select using(true);
create policy "users update own profile" on public.profiles for update using(auth.uid()=id) with check(auth.uid()=id);
create policy "pets public read" on public.pets for select using(true);
create policy "shelters insert pets" on public.pets for insert with check(auth.uid()=owner_id and exists(select 1 from public.profiles where id=auth.uid() and role='refugio'));
create policy "owners update pets" on public.pets for update using(auth.uid()=owner_id) with check(auth.uid()=owner_id);
create policy "owners delete pets" on public.pets for delete using(auth.uid()=owner_id);
create policy "applicants read own" on public.applications for select using(auth.uid()=applicant_id or exists(select 1 from public.pets p where p.id=pet_id and p.owner_id=auth.uid()));
create policy "adopters apply" on public.applications for insert with check(auth.uid()=applicant_id and exists(select 1 from public.profiles where id=auth.uid() and role='adoptante'));
create policy "shelters manage applications" on public.applications for update using(exists(select 1 from public.pets p where p.id=pet_id and p.owner_id=auth.uid()));

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into public.profiles(id,full_name,role,city) values(new.id,coalesce(new.raw_user_meta_data->>'full_name','Usuario'),coalesce((new.raw_user_meta_data->>'role')::user_role,'adoptante'),new.raw_user_meta_data->>'city');return new;end;$$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
