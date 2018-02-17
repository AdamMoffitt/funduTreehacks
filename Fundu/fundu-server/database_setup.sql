create table if not exists users (
  id serial primary key,
  email text unique not null,
  password text not null
);

create table if not exists sessions (
  session text primary key,
  id integer not null references users(id)
);

create table if not exists portfolios (
  user_id integer not null references users(id),
  ticker text not null,
  position integer not null,
  position_start timestamp not null,
  position_end timestamp
);
