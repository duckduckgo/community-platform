alter table instant_answer add column last_modified timestamp with time zone not null default now();

CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER AS $$
BEGIN
   IF row(NEW.*) IS DISTINCT FROM row(OLD.*) THEN
      NEW.last_modified = now(); 
      RETURN NEW;
   ELSE
      RETURN OLD;
   END IF;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ia_modtime BEFORE UPDATE ON instant_answer FOR EACH ROW EXECUTE PROCEDURE update_last_modified();
