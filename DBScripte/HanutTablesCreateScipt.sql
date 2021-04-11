-- Table: "Hanut"
-- first try to drop everything to get a clean installation
-- DROP --
-- Schema: Hanut
DROP SCHEMA IF EXISTS "Hanut" CASCADE;

-- #####################
-- CREATE --
-- Schema: Hanut
CREATE SCHEMA "Hanut"
  AUTHORIZATION postgres;

-- TABLE --
-- Account defition account category
CREATE TABLE "Hanut".acc_def_acc_cat
(
  "mandant" numeric(3,0),
  "accCat" character varying(5) NOT NULL,
  sprache character varying(5) DEFAULT NULL::character varying,
  beschreibung character varying(45) DEFAULT NULL::character varying,

  CONSTRAINT acc_def_acc_cat_pkey PRIMARY KEY ("accCat" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".acc_def_acc_cat
  OWNER TO postgres;
  
-- Rollen
CREATE TABLE "Hanut".gen_roles
(
  "mandant" numeric(3,0),
  "roleID" character varying(10) NOT NULL, -- ID der Rolle, maximal 10 stelliger String
  beschreibung character varying(40), -- Beschreibung der roleID
  CONSTRAINT gen_roles_pkey PRIMARY KEY ("roleID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".gen_roles
  OWNER TO postgres;
COMMENT ON TABLE "Hanut".gen_roles
  IS 'hier werden die Rollen definiert die den einzelnen Usern zugeordnet werden können.';
COMMENT ON COLUMN "Hanut".gen_roles."roleID" IS 'ID der Rolle, maximal 10 stelliger String';
COMMENT ON COLUMN "Hanut".gen_roles.beschreibung IS 'Beschreibung der roleID';
-- Rollen Text
CREATE TABLE "Hanut".gen_roles_text
(
  "mandant" numeric(3,0),
  "roleID" character varying(10) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45),
  CONSTRAINT gen_roles_text_pkey PRIMARY KEY ("roleID" , sprache ),
  CONSTRAINT "gen_roles_text_roleID_fkey" FOREIGN KEY ("roleID")
      REFERENCES "Hanut".gen_roles ("roleID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".gen_roles_text
  OWNER TO postgres;
  
-- Genral User
CREATE TABLE "Hanut".gen_user
(
  "mandant" numeric(3,0),
  "userID" character varying(20) NOT NULL, -- 20 stelliges Benutzerkürzel
  name character varying(80), -- Nachname
  "firstName" character varying(80), -- first name
  CONSTRAINT gen_user_pkey PRIMARY KEY ("userID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".gen_user
  OWNER TO postgres;
COMMENT ON TABLE "Hanut".gen_user
  IS 'Allgemeiner Benutzerstamm';
COMMENT ON COLUMN "Hanut".gen_user."userID" IS '20 stelliges Benutzerkürzel';
COMMENT ON COLUMN "Hanut".gen_user.name IS 'Nachname';
COMMENT ON COLUMN "Hanut".gen_user."firstName" IS 'first name';
-- General User Contact Details
CREATE TABLE "Hanut"."gen_user_contactDetails"
(
  "mandant" numeric(3,0),
  "userID" character varying(20) NOT NULL,
  "contactID" character varying(5) NOT NULL, -- Kann aus einem Nummernkreis genommen werden
  telephone character varying(30),
  "cellPhone" character varying(30),
  email character varying(50),
  street character varying(50),
  "streetNo" character varying(15),
  city character varying(50),
  country character varying(50),
  "zipCodeCity" character varying(15),
  CONSTRAINT "gen_user_contactDetails_pkey" PRIMARY KEY ("userID" , "contactID" ),
  CONSTRAINT "gen_user_contactDetails_userID_fkey" FOREIGN KEY ("userID")
      REFERENCES "Hanut".gen_user ("userID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut"."gen_user_contactDetails"
  OWNER TO postgres;
COMMENT ON COLUMN "Hanut"."gen_user_contactDetails"."contactID" IS 'Kann aus einem Nummernkreis genommen werden';
-- General User Roles
CREATE TABLE "Hanut".gen_user_roles
(
  "mandant" numeric(3,0),
  "userID" character varying(20) NOT NULL,
  "roleID" character varying(10) NOT NULL,
  CONSTRAINT gen_user_roles_pkey PRIMARY KEY ("userID" , "roleID" ),
  CONSTRAINT "gen_user_roles_roleID_fkey" FOREIGN KEY ("roleID")
      REFERENCES "Hanut".gen_roles ("roleID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "gen_user_roles_userID_fkey" FOREIGN KEY ("userID")
      REFERENCES "Hanut".gen_user ("userID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".gen_user_roles
  OWNER TO postgres;

-- ISO Languagecodes
CREATE TABLE "Hanut".iso_def_spachencodes
(
  "mandant" numeric(3,0),
  sprache character varying(5) NOT NULL,
  "ISO_Code" character varying(5) NOT NULL,
  beschreibung character varying(45) NOT NULL,
  CONSTRAINT iso_def_spachencodes_pkey PRIMARY KEY (sprache )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".iso_def_spachencodes
  OWNER TO postgres;

-- Direction types for materials  
CREATE TABLE "Hanut".mat_def_directiontypes
(
  "mandant" numeric(3,0),
  "directionTypeID" character varying(4) NOT NULL,
  sign character varying(1) NOT NULL,
  CONSTRAINT mat_def_directiontypes_pkey PRIMARY KEY ("directionTypeID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_directiontypes
  OWNER TO postgres;

-- Sprachabhängige Texte zu den Direction types  
CREATE TABLE "Hanut".mat_def_directiontype_text
(
  "mandant" numeric(3,0),
  "directionTypeID" character varying(4) NOT NULL,
  sprache character varying(3) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_directiontype_text_pkey PRIMARY KEY ("directionTypeID" , sprache ),
  CONSTRAINT "FK_mat_def_directiontypeID" FOREIGN KEY ("directionTypeID")
      REFERENCES "Hanut".mat_def_directiontypes ("directionTypeID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_directiontype_text
  OWNER TO postgres;
  
-- Konfigurations Schema
CREATE TABLE "Hanut".mat_def_konfig_schema
(
  "mandant" numeric(3,0),
  "konfigSchemaID" character varying(4) NOT NULL,
  "konfigType" character varying(15) DEFAULT NULL::character varying,
  length character varying(1) DEFAULT NULL::character varying,
  "valueRangeFrom" character varying(3) DEFAULT NULL::character varying,
  "valueRangeTo" character varying(3) DEFAULT NULL::character varying,
  schrittweite character varying(3) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_konfig_schema_pkey PRIMARY KEY ("konfigSchemaID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_konfig_schema
  OWNER TO postgres;
  
-- Zugeordnerte Werte des Konfigurationsschemas  
CREATE TABLE "Hanut".mat_def_konfig_schema_assigned_values
(
  "mandant" numeric(3,0),
  "konfigValueID" character varying(3) NOT NULL,
  "konfigSchemaID" character varying(4) NOT NULL,
  "konfigValueBeschreibung" character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_konfig_schema_assigned_values_pkey PRIMARY KEY ("konfigValueID" , "konfigSchemaID" ),
  CONSTRAINT "FK_mat_def_konfig_schema_assigned_values_Schema" FOREIGN KEY ("konfigSchemaID")
      REFERENCES "Hanut".mat_def_konfig_schema ("konfigSchemaID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_konfig_schema_assigned_values
  OWNER TO postgres;
 
-- sprachabhängige Texte für das Konfigurationsschema  
CREATE TABLE "Hanut".mat_def_konfig_schema_text
(
  "mandant" numeric(3,0),
  "konfigSchemaID" character varying(4) NOT NULL,
  sprache character varying(3) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_konfig_schema_text_pkey PRIMARY KEY ("konfigSchemaID" , sprache ),
  CONSTRAINT "FK_mat_def_konfig_schema_text_konfigSchemaID" FOREIGN KEY ("konfigSchemaID")
      REFERENCES "Hanut".mat_def_konfig_schema ("konfigSchemaID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_konfig_schema_text
  OWNER TO postgres;

-- Materialtypen 
CREATE TABLE "Hanut".mat_def_mattype
(
  "mandant" numeric(3,0),
  "matTypeID" character varying(5) NOT NULL,
  numkreis character varying(5) DEFAULT NULL::character varying,
  "externMatid" character varying(1) DEFAULT NULL::character varying,
  "accCat" character varying(5) DEFAULT NULL::character varying,
  "configType" character varying(1) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_mattype_pkey PRIMARY KEY ("matTypeID" ),
  CONSTRAINT "FK_mat_def_mattype_accCat" FOREIGN KEY ("accCat")
      REFERENCES "Hanut".acc_def_acc_cat ("accCat") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_mattype
  OWNER TO postgres;

-- Sprachtexte der Materialtypen  
CREATE TABLE "Hanut".mat_def_mattype_text
(
  "mandant" numeric(3,0),
  "matTypeID" character varying(5) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_mattype_text_pkey PRIMARY KEY ("matTypeID" , sprache ),
  CONSTRAINT "FK_mat_def_mattype_text_1" FOREIGN KEY ("matTypeID")
      REFERENCES "Hanut".mat_def_mattype ("matTypeID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_mattype_text
  OWNER TO postgres;
  
-- Einheiten definition  
CREATE TABLE "Hanut".mat_def_units
(
  "mandant" numeric(3,0),
  unit character varying(3) NOT NULL,
  unit_iso character varying(5) DEFAULT NULL::character varying,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_units_pkey PRIMARY KEY (unit )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_units
  OWNER TO postgres;  
  
-- Sprachtexte der Einheiten  
CREATE TABLE "Hanut".mat_def_units_text
(
  "mandant" numeric(3,0),
  unit character varying(3) NOT NULL,
  sprache character varying(3) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_def_units_text_pkey PRIMARY KEY (unit , sprache ),
  CONSTRAINT "FK_mat_units_text_1" FOREIGN KEY (unit)
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_units_text
  OWNER TO postgres;
  
-- Lager  
CREATE TABLE "Hanut".mat_def_store_store
(
  "mandant" numeric(3,0),
  "storeID" character varying(4) NOT NULL,
  "storeType" character varying(4) DEFAULT NULL::character varying,
  intern character varying(1) DEFAULT NULL::character varying,
  "externalRefno" character varying(45) DEFAULT NULL::character varying,
  "defaultOutputUnit" character varying(3) DEFAULT NULL::character varying,
  "transportGroup" character varying(4) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_store_pkey PRIMARY KEY ("storeID" ),
  CONSTRAINT "FK_mat_store_def_store_OutputUnit" FOREIGN KEY ("defaultOutputUnit")
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_store
  OWNER TO postgres;

-- Sprachabhängige Texte zum Lager
CREATE TABLE "Hanut".mat_def_store_store_text
(
  "mandant" numeric(3,0),
  "storeID" character varying(4) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_storetext_pkey PRIMARY KEY ("storeID" , sprache ),
  CONSTRAINT "FK_mat_store_def_storetext_1" FOREIGN KEY ("storeID")
      REFERENCES "Hanut".mat_def_store_store ("storeID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_store_text
  OWNER TO postgres;

-- Lagerortbedingungen  
CREATE TABLE "Hanut".mat_def_store_roomcondition
(
  "mandant" numeric(3,0),
  "roomCondID" character varying(4) NOT NULL,
  "minTemp" double precision,
  "maxTemp" double precision,
  "minRelHumidity" double precision,
  "maxRelHumidity" double precision,
  "ligthConditions" character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_roomcondition_pkey PRIMARY KEY ("roomCondID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_roomcondition
  OWNER TO postgres;
 
-- Sprachabhängige Texte zu den Lagerortbedingungen  
CREATE TABLE "Hanut".mat_def_store_roomcondition_text
(
  "mandant" numeric(3,0),
  "roomCondID" character varying(4) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_roomcondition_text_pkey PRIMARY KEY ("roomCondID" , sprache ),
  CONSTRAINT "FK_mat_store_def_roomcondition_text" FOREIGN KEY ("roomCondID")
      REFERENCES "Hanut".mat_def_store_roomcondition ("roomCondID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_roomcondition_text
  OWNER TO postgres;

-- Ort des Lagerorts  
CREATE TABLE "Hanut".mat_def_store_store_location
(
  "mandant" numeric(3,0),
  "storeLocationID" character varying(4) NOT NULL,
  length double precision NOT NULL,
  height double precision NOT NULL,
  width double precision NOT NULL,
  "unitDimensions" character varying(3) NOT NULL,
  volume double precision NOT NULL,
  "unitVolume" character varying(3) NOT NULL,
  capacity bigint NOT NULL,
  unit character varying(3) NOT NULL,
  "roomCondID" character varying(4) NOT NULL,
  CONSTRAINT mat_store_def_store_location_pkey PRIMARY KEY ("storeLocationID" ),
  CONSTRAINT "FK_store_location_roomCondID" FOREIGN KEY ("roomCondID")
      REFERENCES "Hanut".mat_def_store_roomcondition ("roomCondID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_store_location_unit" FOREIGN KEY (unit)
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_store_location_unitDimension" FOREIGN KEY (unit)
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_store_location_unitVolume" FOREIGN KEY (unit)
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_store_location
  OWNER TO postgres;
 
-- Sprachabhängige Texte zum Ort des Lagerorts
CREATE TABLE "Hanut".mat_def_store_store_location_text
(
  "mandant" numeric(3,0),
  "storeLocationID" character varying(4) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) NOT NULL,
  CONSTRAINT mat_store_def_store_location_text_pkey PRIMARY KEY ("storeLocationID" , sprache )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_store_location_text
  OWNER TO postgres;
 
-- Zugeordnete Lagerorte  
CREATE TABLE "Hanut".mat_def_store_assigend_storelocation
(
  "mandant" numeric(3,0),
  "storeID" character varying(4) NOT NULL,
  "storeLocationID" character varying(4) NOT NULL,
  CONSTRAINT mat_store_def_assigend_storelocation_pkey PRIMARY KEY ("storeID" , "storeLocationID" ),
  CONSTRAINT "FK_mat_def_store_assigend_storelocation_storeID" FOREIGN KEY ("storeID")
      REFERENCES "Hanut".mat_def_store_store ("storeID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "FK_mat_store_def_assigend_storelocation_storeLocation" FOREIGN KEY ("storeLocationID")
      REFERENCES "Hanut".mat_def_store_store_location ("storeLocationID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_assigend_storelocation
  OWNER TO postgres;
  
  
-- Materialstatus im Lagerort  
CREATE TABLE "Hanut".mat_def_store_matstatus
(
  "mandant" numeric(3,0),
  "statusID" character varying(4) NOT NULL,
  "lockIndicator" character varying(1) DEFAULT NULL::character varying,
  "reasonLock" character varying(40) DEFAULT NULL::character varying,
  "checkMHD" character varying(1) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_matstatus_pkey PRIMARY KEY ("statusID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_matstatus
  OWNER TO postgres;

-- Sprachabhängige Texte zum Materialstatus  
CREATE TABLE "Hanut".mat_def_store_matstatus_text
(
  "mandant" numeric(3,0),
  "statusID" character varying(4) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_matstatus_text_pkey PRIMARY KEY ("statusID" , sprache )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_matstatus_text
  OWNER TO postgres;

-- Transportgruppe im Lager  
CREATE TABLE "Hanut".mat_def_store_transportgroup
(
  "mandant" numeric(3,0),
  "transportgroupID" character varying(3) NOT NULL,
  "transportKategorie" character varying(20) DEFAULT NULL::character varying,
  "transportGeschwindigkeit" character varying(20) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_transportgroup_pkey PRIMARY KEY ("transportgroupID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_transportgroup
  OWNER TO postgres;
  
-- Sprachabhängige Texte zur Transportgruppe
CREATE TABLE "Hanut".mat_def_store_transportgroup_text
(
  "mandant" numeric(3,0),
  "transportgroupID" character varying(4) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_store_def_transportgroup_text_pkey PRIMARY KEY ("transportgroupID" , sprache ),
  CONSTRAINT "FK_mat_store_def_transportgroup_text_1" FOREIGN KEY ("transportgroupID")
      REFERENCES "Hanut".mat_def_store_transportgroup ("transportgroupID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_def_store_transportgroup_text
  OWNER TO postgres; 
  
-- Nummernkreis für Materialien  
CREATE TABLE "Hanut".mat_numberrange
(
  "mandant" numeric(3,0),
  "rangeID" character varying(5) NOT NULL,
  min integer,
  max integer,
  current integer,
  comment character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_numberrange_pkey PRIMARY KEY ("rangeID" )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_numberrange
  OWNER TO postgres;

  
-- Material definition  
CREATE TABLE "Hanut".mat_material
(
  "mandant" numeric(3,0),
  "matID" character varying(20) NOT NULL,
  "matType" character varying(5) DEFAULT NULL::character varying,
  "basicUnit" character varying(3) DEFAULT NULL::character varying,
  "materialHierarchy" character varying(10) DEFAULT NULL::character varying,
  lenght double precision,
  height double precision,
  width double precision,
  "netWeight" double precision,
  "grosWeight" double precision,
  "unitWeight" character varying(3) DEFAULT NULL::character varying,
  "unitDimensions" character varying(3) DEFAULT NULL::character varying,
  "EAN/UPC_Code" character varying(22) DEFAULT NULL::character varying,
  "createdOn" timestamp with time zone,
  "createdBy" character varying(45) DEFAULT NULL::character varying,
  "changedOn" timestamp with time zone,
  "changedBy" character varying(45) DEFAULT NULL::character varying,
  deletionflag character varying(1) DEFAULT NULL::character varying,
  konfig1 character varying(4) DEFAULT NULL::character varying,
  konfig2 character varying(4) DEFAULT NULL::character varying,
  konfig3 character varying(4) DEFAULT NULL::character varying,
  konfig4 character varying(4) DEFAULT NULL::character varying,
  konfig5 character varying(4) DEFAULT NULL::character varying,
  volume double precision,
  "volumeUnit" character varying(3) DEFAULT NULL::character varying,
  "taraGewicht" double precision,
  CONSTRAINT mat_material_pkey PRIMARY KEY ("matID" ),
  CONSTRAINT "FK_mat_material_basicUnit" FOREIGN KEY ("basicUnit")
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_mat_material_unitWeight" FOREIGN KEY ("unitWeight")
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_material_mat_type" FOREIGN KEY ("matType")
      REFERENCES "Hanut".mat_def_mattype ("matTypeID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_material
  OWNER TO postgres;
  
-- Sprachabhängige Texte zum Material  
CREATE TABLE "Hanut".mat_material_text
(
  "mandant" numeric(3,0),
  "matID" character varying(20) NOT NULL,
  sprache character varying(5) NOT NULL,
  beschreibung character varying(45) DEFAULT NULL::character varying,
  CONSTRAINT mat_material_text_pkey PRIMARY KEY ("matID" , sprache )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_material_text
  OWNER TO postgres;

-- Zusätzliche Einheiten für das Material  
CREATE TABLE "Hanut".mat_material_additionalunits
(
  "mandant" numeric(3,0),
  "addUnit" character varying(3) NOT NULL,
  "matID" character varying(20) NOT NULL,
  "conversionFactor" integer NOT NULL,
  "basicUnit" character varying(3) NOT NULL,
  CONSTRAINT mat_material_additionalunits_pkey PRIMARY KEY ("addUnit" , "matID" ),
  CONSTRAINT "FK_mat_additionalunits_2" FOREIGN KEY ("addUnit")
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_mat_additionalunits_3" FOREIGN KEY ("basicUnit")
      REFERENCES "Hanut".mat_def_units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "FK_mat_material_additionalunits_1" FOREIGN KEY ("matID")
      REFERENCES "Hanut".mat_material ("matID") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Hanut".mat_material_additionalunits
  OWNER TO postgres;

