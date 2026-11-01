create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  amount numeric(12,2) not null check (amount > 0),
  category text not null,
  note text,
  date date not null,
  transaction_type text not null check (transaction_type in ('expense','income')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.monthly_budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  month text not null check (month ~ '^\\d{4}-\\d{2}$'),
  amount numeric(12,2) not null check (amount >= 0),
  updated_at timestamptz not null default now(),
  unique(user_id, month)
);
alter table public.transactions enable row level security;
alter table public.monthly_budgets enable row level security;
create policy "own transactions" on public.transactions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own budgets" on public.monthly_budgets for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter publication supabase_realtime add table public.transactions, public.monthly_budgets;
