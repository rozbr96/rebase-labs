
ALTER TABLE exam_type
  ADD CONSTRAINT exam_type_name_key
  UNIQUE (name);
