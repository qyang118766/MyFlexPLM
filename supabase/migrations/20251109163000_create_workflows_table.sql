-- Create workflows table to store drag-and-drop process definitions
create table if not exists workflows (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  definition jsonb not null default '{}'::jsonb,
  create_by text,
  update_by text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists workflows_updated_at_idx on workflows (updated_at desc);

