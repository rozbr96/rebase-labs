
ALTER TABLE doctors
  DROP CONSTRAINT IF EXISTS doctors_crm_key;

ALTER TABLE doctors
  ADD CONSTRAINT doctors_crm_state_key
  UNIQUE (crm, state);
