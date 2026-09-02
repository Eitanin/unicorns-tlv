-- טבלת הסימונים של חדי הקרן.
-- להריץ פעם אחת ב-SQL Editor של פרויקט ה-Supabase החדש.

create table if not exists rsvp (
  id          bigint generated always as identity primary key,
  event_id    text        not null,
  kid         text        not null,
  created_at  timestamptz not null default now(),
  unique (event_id, kid)
);

create index if not exists rsvp_event_idx on rsvp (event_id);

alter table rsvp enable row level security;

-- הלוח פתוח לכל מי שיש לו את הקישור, ולכן גם הכתיבה אנונימית.
-- זו החלטה מודעת: אין כאן נתונים רגישים, רק שמות פרטיים של ילדים בחבורה.
create policy "כולם קוראים" on rsvp
  for select using (true);

create policy "כולם מסמנים" on rsvp
  for insert with check (
    length(kid) between 1 and 40
    and length(event_id) between 1 and 40
  );

create policy "כולם מבטלים" on rsvp
  for delete using (true);
