--
-- Turn off autocommit and start a transaction so that we can use the temp tables
--

SET AUTOCOMMIT FALSE;

START TRANSACTION;

--
-- Insert user information into the temporary tables. To add users to the HSQL database, edit things here.
-- 

INSERT INTO users_TEMP (username, password, enabled) VALUES
  ('admin','password',true),
  ('user','password',true),
  ('gerson','gerson1',true),
  ('magali','magali2',true),
  ('elisa','elisa3',true),
  ('foo','foo',false),
  ('estela','estela4',true);


INSERT INTO authorities_TEMP (username, authority) VALUES
  ('admin','ROLE_ADMIN'),
  ('admin','ROLE_USER'),
  ('user','ROLE_USER'),
  ('gerson','ROLE_ADMIN'),
  ('gerson','ROLE_USER'),
  ('magali','ROLE_USER'),
  ('elisa','ROLE_USER'),  
  ('estela','ROLE_USER'),
  ('foo','ROLE_USER');
    
-- By default, the username column here has to match the username column in the users table, above
INSERT INTO user_info_TEMP (sub,preferred_username,name,birthdate,email,email_verified,phone_number,phone_number_verified,locale,updated_at,address) VALUES
  ('90342.ASDFJWFA','admin','Demo Admin','1980-01-01','admin@teste.example.com',true,'11111',false,'pt-BR','2016-01-01','rua 1'),
  ('01921.FLANRJQW','user','Demo User','1960-01-01','user@alfa.example.com',true,'1111-2222',false,'pt-BR','2016-01-02','rua 22, sao paulo'),
  ('01923.FLANRJQW','gerson','Gerson User','1970-30-07','gerson@example.com',true,'1111-3333',false,'en-US','2016-02-02','street 5, new york'),
  ('01924.FLANRJQW','magali','Magali User','1968-03-28','magali@example.com',true,'1111-44445',false,'pt-BR','2016-03-02','rua sao sebastiao, floripa'),
  ('01925.FLANRJQW','elisa','Elisa User','1996-11-15','elisa@example.com',true,'1111-777777',false,'fr-CA','2015-03-02','rue d paris, paris'),
  ('01926.FLANRJQW','estela','Estela User','2000-02-26','estela@example.com',true,'22222-44445',false,'en-GB','2016-04-02','london'),
  ('01927.FLANRJQW','foo','Foo User','1977-07-07','foo@example.com',true,'333-444-5555',false,'pt-BR','2016-03-27','rua sem nome, cidade sem nome');
  
--
-- Merge the temporary users safely into the database. This is a two-step process to keep users from being created on every startup with a persistent store.
--

MERGE INTO users 
  USING (SELECT username, password, enabled FROM users_TEMP) AS vals(username, password, enabled)
  ON vals.username = users.username
  WHEN NOT MATCHED THEN 
    INSERT (username, password, enabled) VALUES(vals.username, vals.password, vals.enabled);

MERGE INTO authorities 
  USING (SELECT username, authority FROM authorities_TEMP) AS vals(username, authority)
  ON vals.username = authorities.username AND vals.authority = authorities.authority
  WHEN NOT MATCHED THEN 
    INSERT (username,authority) values (vals.username, vals.authority);

MERGE INTO user_info 
  USING (SELECT sub,preferred_username,name,birthdate,email,email_verified,phone_number,phone_number_verified,locale,updated_at,address FROM user_info_TEMP) AS vals(sub,preferred_username,name,birthdate,email,email_verified,phone_number,phone_number_verified,locale,updated_at,address)
  ON vals.preferred_username = user_info.preferred_username
  WHEN NOT MATCHED THEN 
    INSERT (sub,preferred_username,name,birthdate,email,email_verified,phone_number,phone_number_verified,locale,updated_at,address) VALUES (vals.sub, vals.preferred_username, vals.name, vals.birthdate, vals.email, vals.email_verified, vals.phone_number, vals.phone_number_verified, vals.locale, vals.updated_at, vals.address);

    
-- 
-- Close the transaction and turn autocommit back on
-- 
    
COMMIT;

SET AUTOCOMMIT TRUE;

