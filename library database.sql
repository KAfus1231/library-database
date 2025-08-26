
-- Sequences
CREATE SEQUENCE IF NOT EXISTS reader_reader_id_seq;
CREATE SEQUENCE IF NOT EXISTS support_chat_chat_id_seq;
CREATE SEQUENCE IF NOT EXISTS storage_storage_id_seq;
CREATE SEQUENCE IF NOT EXISTS author_author_id_seq;
CREATE SEQUENCE IF NOT EXISTS library_card_card_id_seq;
CREATE SEQUENCE IF NOT EXISTS message_message_id_seq;
CREATE SEQUENCE IF NOT EXISTS operation_operation_id_seq;
CREATE SEQUENCE IF NOT EXISTS book_order_order_id_seq;
CREATE SEQUENCE IF NOT EXISTS address_address_id_seq;
CREATE SEQUENCE IF NOT EXISTS purchase_purchase_id_seq;
CREATE SEQUENCE IF NOT EXISTS book_book_id_seq;
CREATE SEQUENCE IF NOT EXISTS document_document_id_seq;
CREATE SEQUENCE IF NOT EXISTS employee_employee_id_seq;
CREATE SEQUENCE IF NOT EXISTS library_library_id_seq;
CREATE SEQUENCE IF NOT EXISTS publisher_publisher_id_seq;
CREATE SEQUENCE IF NOT EXISTS genre_genre_id_seq;

-- Tables
CREATE TABLE IF NOT EXISTS reader (
  reader_id integer NOT NULL DEFAULT nextval('reader_reader_id_seq') PRIMARY KEY,
  full_name character varying NOT NULL,
  contact_info character varying NOT NULL,
  status text NOT NULL
);

CREATE TABLE IF NOT EXISTS support_chat (
  chat_id integer NOT NULL DEFAULT nextval('support_chat_chat_id_seq') PRIMARY KEY,
  topic character varying NOT NULL
);

CREATE TABLE IF NOT EXISTS order_item (
  order_id integer NOT NULL,
  book_id integer NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  PRIMARY KEY (order_id, book_id)
);

CREATE TABLE IF NOT EXISTS storage (
  storage_id integer NOT NULL DEFAULT nextval('storage_storage_id_seq') PRIMARY KEY,
  storage_type text NOT NULL,
  conditions text NOT NULL,
  library_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS author (
  author_id integer NOT NULL DEFAULT nextval('author_author_id_seq') PRIMARY KEY,
  full_name character varying NOT NULL,
  biography text NOT NULL
);

CREATE TABLE IF NOT EXISTS library_card (
  card_id serial NOT NULL PRIMARY KEY,
  reader_id integer NOT NULL,
  card_number character varying NOT NULL,
  issue_date date NOT NULL,
  expiry_date date NOT NULL,
  status text NOT NULL,
  outstanding_fines numeric(10, 2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS message (
  message_id serial NOT NULL PRIMARY KEY,
  chat_id integer NOT NULL,
  sender_id integer NOT NULL,
  message_text text NOT NULL,
  sent_at timestamp without time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS operation (
  operation_id serial NOT NULL PRIMARY KEY,
  operation_type text NOT NULL,
  operation_date timestamp without time zone NOT NULL,
  reader_id integer NOT NULL,
  employee_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS book_order (
  order_id integer NOT NULL DEFAULT nextval('book_order_order_id_seq') PRIMARY KEY,
  order_date timestamp without time zone NOT NULL,
  status character varying NOT NULL,
  reader_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS purchase_item (
  purchase_item_id serial NOT NULL PRIMARY KEY,
  purchase_id integer NOT NULL,
  book_id integer NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  unit_cost numeric(12, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS address (
  address_id integer NOT NULL DEFAULT nextval('address_address_id_seq') PRIMARY KEY,
  street character varying NOT NULL,
  city character varying NOT NULL,
  postal_code character varying NOT NULL,
  country character varying NOT NULL
);

CREATE TABLE IF NOT EXISTS book_author (
  book_author_id serial NOT NULL PRIMARY KEY,
  book_id integer NOT NULL,
  author_id integer NOT NULL,
  UNIQUE (book_id, author_id)
);

CREATE TABLE IF NOT EXISTS purchase (
  purchase_id integer NOT NULL DEFAULT nextval('purchase_purchase_id_seq') PRIMARY KEY,
  purchase_date timestamp without time zone NOT NULL,
  total_cost numeric(12, 2) NOT NULL,
  payment_terms character varying NOT NULL,
  publisher_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS book (
  book_id integer NOT NULL DEFAULT nextval('book_book_id_seq') PRIMARY KEY,
  title character varying NOT NULL,
  publication_year integer NOT NULL,
  copies_count integer NOT NULL DEFAULT 0,
  publisher_id integer NOT NULL,
  storage_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS document (
  document_id serial NOT NULL PRIMARY KEY,
  document_type text NOT NULL,
  creation_date date NOT NULL,
  library_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS employee (
  employee_id integer NOT NULL DEFAULT nextval('employee_employee_id_seq') PRIMARY KEY,
  full_name character varying NOT NULL,
  position character varying NOT NULL,
  library_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS library (
  library_id integer NOT NULL DEFAULT nextval('library_library_id_seq') PRIMARY KEY,
  name character varying NOT NULL,
  address_id integer NOT NULL,
  contact_info character varying NOT NULL,
  hours text NOT NULL
);

CREATE TABLE IF NOT EXISTS publisher (
  publisher_id integer NOT NULL DEFAULT nextval('publisher_publisher_id_seq') PRIMARY KEY,
  name character varying NOT NULL,
  contact_info character varying NOT NULL,
  address_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS genre (
  genre_id integer NOT NULL DEFAULT nextval('genre_genre_id_seq') PRIMARY KEY,
  name character varying NOT NULL,
  description text NOT NULL
);

CREATE TABLE IF NOT EXISTS book_genre (
  book_genre_id serial NOT NULL PRIMARY KEY,
  book_id integer NOT NULL,
  genre_id integer NOT NULL,
  UNIQUE (book_id, genre_id)
);

-- Drop and recreate constraints to avoid duplicates
ALTER TABLE IF EXISTS book_author DROP CONSTRAINT IF EXISTS book_author_author_fk;
ALTER TABLE IF EXISTS book_author ADD CONSTRAINT book_author_author_fk FOREIGN KEY (author_id) REFERENCES author (author_id);

ALTER TABLE IF EXISTS book_author DROP CONSTRAINT IF EXISTS book_author_book_fk;
ALTER TABLE IF EXISTS book_author ADD CONSTRAINT book_author_book_fk FOREIGN KEY (book_id) REFERENCES book (book_id);

ALTER TABLE IF EXISTS book_genre DROP CONSTRAINT IF EXISTS book_genre_book_fk;
ALTER TABLE IF EXISTS book_genre ADD CONSTRAINT book_genre_book_fk FOREIGN KEY (book_id) REFERENCES book (book_id);

ALTER TABLE IF EXISTS book_genre DROP CONSTRAINT IF EXISTS book_genre_genre_fk;
ALTER TABLE IF EXISTS book_genre ADD CONSTRAINT book_genre_genre_fk FOREIGN KEY (genre_id) REFERENCES genre (genre_id);

ALTER TABLE IF EXISTS book_order DROP CONSTRAINT IF EXISTS book_order_reader_fk;
ALTER TABLE IF EXISTS book_order ADD CONSTRAINT book_order_reader_fk FOREIGN KEY (reader_id) REFERENCES reader (reader_id);

ALTER TABLE IF EXISTS book DROP CONSTRAINT IF EXISTS book_publisher_fk;
ALTER TABLE IF EXISTS book ADD CONSTRAINT book_publisher_fk FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id);

ALTER TABLE IF EXISTS book DROP CONSTRAINT IF EXISTS book_storage_fk;
ALTER TABLE IF EXISTS book ADD CONSTRAINT book_storage_fk FOREIGN KEY (storage_id) REFERENCES storage (storage_id);

ALTER TABLE IF EXISTS document DROP CONSTRAINT IF EXISTS document_library_fk;
ALTER TABLE IF EXISTS document ADD CONSTRAINT document_library_fk FOREIGN KEY (library_id) REFERENCES library (library_id);

ALTER TABLE IF EXISTS employee DROP CONSTRAINT IF EXISTS employee_library_fk;
ALTER TABLE IF EXISTS employee ADD CONSTRAINT employee_library_fk FOREIGN KEY (library_id) REFERENCES library (library_id);

ALTER TABLE IF EXISTS library DROP CONSTRAINT IF EXISTS library_address_fk;
ALTER TABLE IF EXISTS library ADD CONSTRAINT library_address_fk FOREIGN KEY (address_id) REFERENCES address (address_id);

ALTER TABLE IF EXISTS library_card DROP CONSTRAINT IF EXISTS library_card_reader_fk;
ALTER TABLE IF EXISTS library_card ADD CONSTRAINT library_card_reader_fk FOREIGN KEY (reader_id) REFERENCES reader (reader_id);

ALTER TABLE IF EXISTS message DROP CONSTRAINT IF EXISTS message_chat_fk;
ALTER TABLE IF EXISTS message ADD CONSTRAINT message_chat_fk FOREIGN KEY (chat_id) REFERENCES support_chat (chat_id);

ALTER TABLE IF EXISTS message DROP CONSTRAINT IF EXISTS message_sender_reader_fk;
ALTER TABLE IF EXISTS message ADD CONSTRAINT message_sender_reader_fk FOREIGN KEY (sender_id) REFERENCES reader (reader_id);

ALTER TABLE IF EXISTS operation DROP CONSTRAINT IF EXISTS operation_employee_fk;
ALTER TABLE IF EXISTS operation ADD CONSTRAINT operation_employee_fk FOREIGN KEY (employee_id) REFERENCES employee (employee_id);

ALTER TABLE IF EXISTS operation DROP CONSTRAINT IF EXISTS operation_reader_fk;
ALTER TABLE IF EXISTS operation ADD CONSTRAINT operation_reader_fk FOREIGN KEY (reader_id) REFERENCES reader (reader_id);

ALTER TABLE IF EXISTS order_item DROP CONSTRAINT IF EXISTS order_item_book_fk;
ALTER TABLE IF EXISTS order_item ADD CONSTRAINT order_item_book_fk FOREIGN KEY (book_id) REFERENCES book (book_id);

ALTER TABLE IF EXISTS order_item DROP CONSTRAINT IF EXISTS order_item_order_fk;
ALTER TABLE IF EXISTS order_item ADD CONSTRAINT order_item_order_fk FOREIGN KEY (order_id) REFERENCES book_order (order_id);

ALTER TABLE IF EXISTS publisher DROP CONSTRAINT IF EXISTS publisher_address_fk;
ALTER TABLE IF EXISTS publisher ADD CONSTRAINT publisher_address_fk FOREIGN KEY (address_id) REFERENCES address (address_id);

ALTER TABLE IF EXISTS purchase_item DROP CONSTRAINT IF EXISTS purchase_item_book_fk;
ALTER TABLE IF EXISTS purchase_item ADD CONSTRAINT purchase_item_book_fk FOREIGN KEY (book_id) REFERENCES book (book_id);

ALTER TABLE IF EXISTS purchase_item DROP CONSTRAINT IF EXISTS purchase_item_purchase_fk;
ALTER TABLE IF EXISTS purchase_item ADD CONSTRAINT purchase_item_purchase_fk FOREIGN KEY (purchase_id) REFERENCES purchase (purchase_id);

ALTER TABLE IF EXISTS purchase DROP CONSTRAINT IF EXISTS purchase_publisher_fk;
ALTER TABLE IF EXISTS purchase ADD CONSTRAINT purchase_publisher_fk FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id);

ALTER TABLE IF EXISTS storage DROP CONSTRAINT IF EXISTS storage_library_fk;
ALTER TABLE IF EXISTS storage ADD CONSTRAINT storage_library_fk FOREIGN KEY (library_id) REFERENCES library (library_id);

