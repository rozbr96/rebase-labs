
ALTER TABLE doctor
  DROP CONSTRAINT IF EXISTS doctor_crm_key;

ALTER TABLE doctor
  ADD CONSTRAINT doctor_crm_state_key
  UNIQUE (crm, state);
