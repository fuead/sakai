-- SAK-30207
CREATE TABLE IF NOT EXISTS CONTENTREVIEW_ITEM (
    ID                  BIGINT NOT NULL AUTO_INCREMENT,
    VERSION             INT NOT NULL,
    PROVIDERID          INT NOT NULL,
    CONTENTID           VARCHAR(255) NOT NULL,
    USERID              VARCHAR(255),
    SITEID              VARCHAR(255),
    TASKID              VARCHAR(255),
    EXTERNALID          VARCHAR(255),
    DATEQUEUED          DATETIME NOT NULL,
    DATESUBMITTED       DATETIME,
    DATEREPORTRECEIVED  DATETIME,
    STATUS              BIGINT,
    REVIEWSCORE         INT,
    LASTERROR           LONGTEXT,
    RETRYCOUNT          BIGINT,
    NEXTRETRYTIME       DATETIME NOT NULL,
    ERRORCODE           INT,
    PRIMARY KEY (ID),
    CONSTRAINT PROVIDERID UNIQUE (PROVIDERID, CONTENTID)
);
-- END SAK-30207

-- ------------------------------
-- DASHBOARD                -----
-- ------------------------------
      
create table dash_availability_check 
( id bigint not null auto_increment, entity_ref varchar(255) not null, 
entity_type_id varchar(255) not null, scheduled_time datetime not null, primary key (id)); 
create unique index dash_availability_check_idx on dash_availability_check(entity_ref, scheduled_time); 
create index dash_availability_check_time_idx on dash_availability_check(scheduled_time);

create table if not exists dash_calendar_item ( id bigint not null auto_increment, 
calendar_time datetime not null, calendar_time_label_key varchar(40), title varchar(255) not null, 
entity_ref varchar(255) not null, entity_type bigint not null, subtype varchar(255), context_id bigint not null, 
repeating_event_id bigint, sequence_num integer, primary key (id) ); 
create index dash_calendar_time_idx on dash_calendar_item (calendar_time); 
create unique index dash_calendar_entity_label_idx on dash_calendar_item (entity_ref, calendar_time_label_key, sequence_num); 
create index dash_calendar_entity_idx on dash_calendar_item (entity_ref); 

create table if not exists dash_calendar_link ( id bigint not null auto_increment, 
person_id bigint not null, context_id bigint not null, item_id bigint not null, hidden bit default 0, 
sticky bit default 0, unique (person_id, context_id, item_id), primary key (id) ); 
create index dash_calendar_link_idx on dash_calendar_link (person_id, context_id, item_id, hidden, sticky);
create index dash_calendar_link_item_id_idx on dash_calendar_link (item_id);

create table if not exists dash_config ( id bigint not null auto_increment, 
property_name varchar(99) not null, property_value integer not null, primary key (id) ); 
create unique index dash_config_name_idx on dash_config(property_name); 
insert into dash_config (property_name, property_value) values ('PROP_DEFAULT_ITEMS_IN_PANEL', 5); 
insert into dash_config (property_name, property_value) values ('PROP_DEFAULT_ITEMS_IN_DISCLOSURE', 20); 
insert into dash_config (property_name, property_value) values ('PROP_DEFAULT_ITEMS_IN_GROUP', 2); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_NEWS_ITEMS_AFTER_WEEKS', 8); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_STARRED_NEWS_ITEMS_AFTER_WEEKS', 26); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_HIDDEN_NEWS_ITEMS_AFTER_WEEKS', 4); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_CALENDAR_ITEMS_AFTER_WEEKS', 2); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_STARRED_CALENDAR_ITEMS_AFTER_WEEKS', 26); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_HIDDEN_CALENDAR_ITEMS_AFTER_WEEKS', 1); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_NEWS_ITEMS_WITH_NO_LINKS', 1); 
insert into dash_config (property_name, property_value) values ('PROP_REMOVE_CALENDAR_ITEMS_WITH_NO_LINKS', 1); 
insert into dash_config (property_name, property_value) values ('PROP_DAYS_BETWEEN_HORIZ0N_UPDATES', 1); 
insert into dash_config (property_name, property_value) values ('PROP_WEEKS_TO_HORIZON', 4); 
insert into dash_config (property_name, property_value) values ('PROP_MOTD_MODE', 1); 
insert into dash_config (property_name, property_value) values ('PROP_LOG_MODE_FOR_NAVIGATION_EVENTS', 2); 
insert into dash_config (property_name, property_value) values ('PROP_LOG_MODE_FOR_ITEM_DETAIL_EVENTS', 2); 
insert into dash_config (property_name, property_value) values ('PROP_LOG_MODE_FOR_PREFERENCE_EVENTS', 2); 
insert into dash_config (property_name, property_value) values ('PROP_LOG_MODE_FOR_DASH_NAV_EVENTS', 2);
insert into dash_config (property_name, property_value) values ('PROP_LOOP_TIMER_ENABLED', 0);


create table if not exists dash_context ( id bigint not null auto_increment, context_id varchar(255) not null, 
context_url varchar(1024) not null, context_title varchar(255) not null, primary key (id) ); 
create unique index dash_context_idx on dash_context (context_id);

create table dash_event (event_id bigint auto_increment, event_date timestamp, event varchar (32), 
ref varchar (255), context varchar (255), session_id varchar (163), event_code varchar (1), primary key (event_id));

create table if not exists dash_news_item ( id bigint not null auto_increment, news_time datetime not null, 
news_time_label_key varchar(40), title varchar(255) not null, 
entity_ref varchar(255) not null, entity_type bigint not null, subtype varchar(255), 
context_id bigint not null, grouping_id varchar(90), primary key (id) ); 
create index dash_news_time_idx on dash_news_item (news_time); 
create index dash_news_grouping_idx on dash_news_item (grouping_id); 
create unique index dash_news_entity_idx on dash_news_item (entity_ref);

create table if not exists dash_news_link ( id bigint not null auto_increment, person_id bigint not null, 
context_id bigint not null, item_id bigint not null, hidden bit default 0, sticky bit default 0, 
unique (person_id, context_id, item_id), primary key (id) ); 
create index dash_news_link_idx on dash_news_link (person_id, context_id, item_id, hidden, sticky);
create index dash_news_link_item_id_idx on dash_news_link (item_id);

create table if not exists dash_person ( id bigint not null auto_increment,user_id varchar(99) not null,
sakai_id varchar(99), primary key (id) ); 
create unique index dash_person_user_id_idx on dash_person (user_id); 
create unique index dash_person_sakai_id_idx on dash_person (sakai_id);

create table if not exists dash_repeating_event (id bigint not null auto_increment, 
first_time datetime not null, last_time datetime, frequency varchar(40) not null, max_count integer, 
calendar_time_label_key varchar(40), title varchar(255) not null, 
entity_ref varchar(265) not null, subtype varchar(255), entity_type bigint not null, context_id bigint not null, 
primary key (id) ); 
create index dash_repeating_event_first_idx on dash_repeating_event (first_time); 
create index dash_repeating_event_last_idx on dash_repeating_event (last_time);

create table if not exists dash_sourcetype 
( id bigint not null auto_increment, identifier varchar(255) not null, primary key (id) ); 
create unique index dash_source_idx on dash_sourcetype (identifier);

create table if not exists dash_task_lock
( id bigint not null auto_increment, 
task varchar(255) not null, 
server_id varchar(255) not null, 
claim_time timestamp, 
last_update timestamp, 
has_lock bit default 0,
primary key (id));
create index dash_lock_ct_idx on dash_task_lock (claim_time); 
create unique index dash_lock_ts_idx on dash_task_lock (task, server_id);

--
-- SAK-27929 Add Dashboard to default !user site
--

INSERT INTO SAKAI_SITE_PAGE VALUES('!user-99', '!user', 'Dashboard', '0', 0, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-999', '!user-99', '!user', 'sakai.dashboard', 1, 'Dashboard', NULL );

-- 
-- SAK-31641 Switch from INTs to VARCHARs in Oauth
-- 
ALTER TABLE OAUTH_ACCESSORS
CHANGE
  status status VARCHAR(255),
  CHANGE type type VARCHAR(255)
;

UPDATE OAUTH_ACCESSORS SET status = CASE
  WHEN status = 0 THEN "VALID"
  WHEN status = 1 THEN "REVOKED"
  WHEN status = 2 THEN "EXPIRED"
END;

UPDATE OAUTH_ACCESSORS SET type = CASE
  WHEN type = 0 THEN "REQUEST"
  WHEN type = 1 THEN "REQUEST_AUTHORISING"
  WHEN type = 2 THEN "REQUEST_AUTHORISED"
  WHEN type = 3 THEN "ACCESS"
END;

--
-- SAK-31636 Rename existing 'Home' tools
--

update SAKAI_SITE_PAGE set title = 'Overview' where title = 'Home';

-- SAK-31136 some old Sakai MySQL databases have shorter data limits 
ALTER TABLE MFR_MESSAGE_T MODIFY BODY LONGTEXT;
ALTER TABLE MFR_TOPIC_T MODIFY EXTENDED_DESCRIPTION LONGTEXT;
ALTER TABLE MFR_OPEN_FORUM_T MODIFY EXTENDED_DESCRIPTION LONGTEXT;
ALTER TABLE MFR_PRIVATE_FORUM_T MODIFY EXTENDED_DESCRIPTION LONGTEXT;
-- END SAK-31136

--
-- SAK-31563
--

-- Add new user_id columns and their corresponding indexes
ALTER TABLE pasystem_popup_assign ADD user_id varchar(99);
ALTER TABLE pasystem_popup_dismissed ADD user_id varchar(99);
ALTER TABLE pasystem_banner_dismissed ADD user_id varchar(99);

CREATE INDEX popup_assign_lower_user_id on pasystem_popup_assign (user_id);
CREATE INDEX popup_dismissed_lower_user_id on pasystem_popup_dismissed (user_id);
CREATE INDEX banner_dismissed_user_id on pasystem_banner_dismissed (user_id);

-- Map existing EIDs to their corresponding user IDs
update pasystem_popup_assign popup set user_id = (select user_id from sakai_user_id_map map where popup.user_eid = map.eid);
update pasystem_popup_dismissed popup set user_id = (select user_id from sakai_user_id_map map where popup.user_eid = map.eid);
update pasystem_banner_dismissed banner set user_id = (select user_id from sakai_user_id_map map where banner.user_eid = map.eid);

-- Any rows that couldn't be mapped are dropped (there shouldn't
-- really be any, but if there are those users were already being
-- ignored when identified by EID)
DELETE FROM pasystem_popup_assign WHERE user_id is null;
DELETE FROM pasystem_popup_dismissed WHERE user_id is null;
DELETE FROM pasystem_banner_dismissed WHERE user_id is null;

-- Enforce NULL checks on the new columns
ALTER TABLE pasystem_popup_assign MODIFY user_id varchar(99) NOT NULL;
ALTER TABLE pasystem_popup_dismissed MODIFY user_id varchar(99) NOT NULL;
ALTER TABLE pasystem_banner_dismissed MODIFY user_id varchar(99) NOT NULL;

-- Reintroduce unique constraints for the new column
ALTER TABLE pasystem_popup_dismissed drop INDEX unique_popup_dismissed;
ALTER TABLE pasystem_popup_dismissed add UNIQUE INDEX unique_popup_dismissed (user_id, state, uuid);

ALTER TABLE pasystem_banner_dismissed drop INDEX unique_banner_dismissed;
ALTER TABLE pasystem_banner_dismissed add UNIQUE INDEX unique_banner_dismissed (user_id, state, uuid);

-- Drop the old columns
ALTER TABLE pasystem_popup_assign DROP COLUMN user_eid;
ALTER TABLE pasystem_popup_dismissed DROP COLUMN user_eid;
ALTER TABLE pasystem_banner_dismissed DROP COLUMN user_eid;

--
-- SAK-31840 drop defaults as its now managed in the POJO
--
alter table GB_GRADABLE_OBJECT_T alter column IS_EXTRA_CREDIT drop default;
alter table GB_GRADABLE_OBJECT_T alter column HIDE_IN_ALL_GRADES_TABLE drop default;

-- BEGIN SAM-3066 remove unecessary indexes because Hibernate always create an index on an FK
ALTER TABLE SAM_PUBLISHEDITEM_T DROP INDEX SAM_PUBITEM_SECTION_I;
ALTER TABLE SAM_PUBLISHEDITEMFEEDBACK_T DROP INDEX SAM_PUBITEMFB_ITEM_I;
ALTER TABLE SAM_PUBLISHEDITEMMETADATA_T DROP INDEX SAM_PUBITEMMETA_ITEM_I;
ALTER TABLE SAM_PUBLISHEDITEMTEXT_T DROP INDEX SAM_PUBITEMTEXT_ITEM_I;
ALTER TABLE SAM_PUBLISHEDSECTION_T DROP INDEX SAM_PUBSECTION_ASSESSMENT_I;
ALTER TABLE SAM_PUBSECTION_ASSESSMENT_I DROP INDEX SAM_PUBITEM_SECTION_I;
ALTER TABLE SAM_PUBLISHEDSECUREDIP_T DROP INDEX SAM_PUBIP_ASSESSMENT_I;
ALTER TABLE SAM_PUBLISHEDSECTIONMETADATA_T DROP INDEX SAM_PUBSECTIONMETA_SECTION_I;
ALTER TABLE SAM_ANSWER_T DROP INDEX SAM_ANSWER_ITEMTEXTID_I;
-- END SAM-3066

-- BEGIN SAK-31819 Remove the old ScheduledInvocationManager job as it's not present in Sakai 12.
DELETE FROM QRTZ_SIMPLE_TRIGGERS WHERE TRIGGER_NAME='org.sakaiproject.component.app.scheduler.ScheduledInvocationManagerImpl.runner';
DELETE FROM QRTZ_TRIGGERS WHERE TRIGGER_NAME='org.sakaiproject.component.app.scheduler.ScheduledInvocationManagerImpl.runner';
-- This one is the actual job that the triggers were trying to run
DELETE FROM QRTZ_JOB_DETAILS WHERE JOB_NAME='org.sakaiproject.component.app.scheduler.ScheduledInvocationManagerImpl.runner';
-- END SAK-31819
