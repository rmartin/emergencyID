//create contact category code
CREATE TABLE contactCategory ( contactCategoryId Integer PRIMARY KEY NOT NULL, title varchar NOT NULL, rank Integer NOT NULL DEFAULT '0')

//create contact 
CREATE TABLE contact ( contactId Integer PRIMARY KEY NOT NULL, contactCategoryId Integer NOT NULL, userId Integer NULL, firstName Varchar NULL, lastName Varchar NULL, phone Varchar NULL, image Varchar NULL)