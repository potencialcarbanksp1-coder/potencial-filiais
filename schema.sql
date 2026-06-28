-- ============================================================
-- GCM Panel — Schema Supabase
-- Execute este script no SQL Editor do Supabase
-- ============================================================

create table if not exists lojas (
  id             bigserial primary key,
  cnpj_loja      text unique not null,
  razao_loja     text,
  nome_fantasia  text,
  cidade         text,
  uf             text,
  regiao         text,
  divisao        text,
  regional       text,
  status_loja    text,
  vol_leves_perfil_cb  numeric default 0,
  qt_leves_cb          integer default 0,
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);

-- Índices para performance
create index if not exists idx_lojas_regiao on lojas (regiao);
create index if not exists idx_lojas_uf on lojas (uf);

-- Trigger para updated_at automático
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_lojas_updated_at on lojas;
create trigger trg_lojas_updated_at
  before update on lojas
  for each row execute function set_updated_at();

-- RLS: permite leitura pública (ajuste conforme sua política de segurança)
alter table lojas enable row level security;

create policy "Leitura pública" on lojas
  for select using (true);

create policy "Inserção autenticada" on lojas
  for insert with check (true);

create policy "Update autenticado" on lojas
  for update using (true);

-- ============================================================
-- VERIFICAÇÃO — execute para confirmar a estrutura
-- ============================================================
-- select column_name, data_type from information_schema.columns
-- where table_name = 'lojas' order by ordinal_position;
