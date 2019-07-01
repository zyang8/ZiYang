CREATE TABLE P_CITY_LOCATION (
      LOCATION_ID 	       CHAR(5) 	            NOT NULL,
      LOC_DESC             VARCHAR2(200)        NULL,
      GPS_LAT              NUMBER(10,7)         NULL,
      GPS_LON              NUMBER(10,7)         NULL,
      CONSTRAINT 	P_CITY_LOCATION_PK      PRIMARY KEY(LOCATION_ID)
      );
      
CREATE TABLE P_RECYCLING_ORG (
      ORG_ID              CHAR(5)                 NOT NULL,
      ORG_NAME            VARCHAR2(500)           NOT NULL,
      ORG_STREET1         VARCHAR2(500)           NOT NULL,
      ORG_STREET2         VARCHAR2(500)           NULL,
      ORG_CITY            VARCHAR2(20)            DEFAULT 'San Diego'     NOT NULL,
      ORG_STATE           CHAR(2)                 DEFAULT 'CA'            NOT NULL,
      ORG_ZIP             CHAR(5)                 NULL,
      DATE_ADDED          DATE                    DEFAULT SYSDATE         NOT NULL,
      CONTACT_LNAME       VARCHAR2(50)            NULL,
      CONTACT_FNAME       VARCHAR2(30)            NULL,
      CONTACT_EMAIL       VARCHAR2(100)           NULL,
      CONSTRAINT      P_RECYCLING_ORG_PK      PRIMARY KEY(ORG_ID),
      CONSTRAINT      P_RECYCLING_ORG_UK1     UNIQUE(ORG_NAME,ORG_STREET1,ORG_CITY,ORG_STATE),
      CONSTRAINT      DATA_ADDED_RANGE        CHECK (DATE_ADDED >= TO_DATE('01-01-1997','MM-DD-YYYY')),
      CONSTRAINT      EMAIL_CHK               CHECK (CONTACT_EMAIL LIKE '%__@%__.__%'),
      CONSTRAINT      ORG_STATE_CHK           CHECK (ORG_STATE IN ('CA','NV','OR','AZ'))
      );

CREATE TABLE P_WASTE_CATEG (
      WC_ID               CHAR(5)                 NOT NULL,
      WC_DESC             VARCHAR2(1000)          NOT NULL,
      WEIGHT_CUFT         NUMBER(5,2)             NULL,
      FORM                CHAR(15)                DEFAULT'Loose Solid'    NOT NULL,
      WASTETYPE           CHAR(15)                DEFAULT'B'              NOT NULL,
      DATE_ADDED          DATE                    DEFAULT SYSDATE         NOT NULL,
      DATE_REVIEWED       DATE                    NULL,
      CONSTRAINT      P_WASTE_CATEG_PK        PRIMARY KEY(WC_ID),
      CONSTRAINT      FORM_CHK                CHECK (FORM IN ('Loose Solid','Block Solid','Liquid','Physical Unit','Gaseous Containers')),
      CONSTRAINT      WEIGHT_CUFT_RANGE       CHECK ((WEIGHT_CUFT > 0) AND (WEIGHT_CUFT <= 1500)),
      CONSTRAINT      WASTETYPE_CHK           CHECK (WASTETYPE IN ('R','E','N')),
      CONSTRAINT      DATE_CHK                CHECK (DATE_REVIEWED >= DATE_ADDED)
      );
    
CREATE TABLE P_DO_SITE (
      ORG_ID 	         CHAR(5) 	        NOT NULL,
      SITE_NUM           CHAR(3)    	    NOT NULL,
      GPS_LAT            NUMBER(10,7)       NOT NULL,
      GPS_LON            NUMBER(10,7)       NOT NULL,
      SITE_STREET1       VARCHAR2(50)       NOT NULL,
      SITE_STREET2       VARCHAR2(50)       NULL,
      SITE_CITY          VARCHAR2(20)       DEFAULT 'San Diego'     NOT NULL,
      SITE_STATE         CHAR(2)            DEFAULT 'CA'            NOT NULL,
      SITE_ZIP           CHAR(5)            NULL,
      CONSTRAINT    P_DO_DITE_FK         FOREIGN KEY(ORG_ID) REFERENCES P_RECYCLING_ORG(ORG_ID),      
      CONSTRAINT 	P_DO_SITE_PK         PRIMARY KEY(ORG_ID,SITE_NUM),
      CONSTRAINT 	P_DO_SITE_UK1    UNIQUE(GPS_LAT,GPS_LON),
      CONSTRAINT 	P_DO_SITE_UK2    UNIQUE(SITE_STREET1,SITE_CITY,SITE_STATE),
      CONSTRAINT 	GPS_LAT_RANGE 	  CHECK ((GPS_LAT >= 32.5) AND (GPS_LAT <= 33)),
      CONSTRAINT 	GPS_LON_RANGE 	  CHECK ((GPS_LON >= -117.4) AND (GPS_LON <= -116.7))
      );
      
CREATE TABLE P_DISTANCE (
      LOC_ID           CHAR(5)         NOT NULL ,
      ORG_ID           CHAR(5)         NOT NULL ,
      SITE_NUM         CHAR(3)         NOT NULL ,
      DISTANCE_MILES   NUMBER(6,3)     NULL,
      CONSTRAINT    P_DISTANCE_FK1  FOREIGN KEY(LOC_ID) 
                                REFERENCES P_CITY_LOCATION(LOCATION_ID),
      CONSTRAINT    P_DISTANCE_FK2  FOREIGN KEY(ORG_ID,SITE_NUM) 
                                REFERENCES P_DO_SITE(ORG_ID,SITE_NUM),
      CONSTRAINT    P_DISTANCE_PK   PRIMARY KEY(LOC_ID,ORG_ID,SITE_NUM)
      );
      
CREATE TABLE P_DO_SITE_WC_INT (
      WC_ID 	    CHAR(5) 	        NOT NULL,
      ORG_ID 	    CHAR(5) 	        NOT NULL,
      DO_SITENUM    CHAR(3) 	        NOT NULL,
      CONSTRAINT    P_DO_SITE_WC_INT_FK1    FOREIGN KEY(WC_ID) 
                                REFERENCES P_WASTE_CATEG(WC_ID),
      CONSTRAINT    P_DO_SITE_WC_INT_FK2    FOREIGN KEY(ORG_ID,DO_SITENUM) 
                                REFERENCES P_DO_SITE(ORG_ID,SITE_NUM),      
      CONSTRAINT 	P_DO_SITE_WC_INT_PK     PRIMARY KEY(WC_ID,ORG_ID,DO_SITENUM)
      );

CREATE TABLE P_EPA_WASTE (
      WC_ID 	    CHAR(5) 	        NOT NULL,
      EPA_CODE      CHAR(10) 	        DEFAULT 'EPA67341US'    NOT NULL,
      CONSTRAINT    P_EPA_WASTE_FK   FOREIGN KEY(WC_ID) 
                                REFERENCES P_WASTE_CATEG(WC_ID),      
      CONSTRAINT 	P_EPA_WASTE_PK   PRIMARY KEY(WC_ID)
      );

CREATE TABLE P_REIMBURSED (
      WC_ID 	        CHAR(5) 	    NOT NULL,
      PRICE_PER_LB      NUMBER(8,2) 	NOT NULL,
      CONSTRAINT    P_REIMBURSED_FK     FOREIGN KEY(WC_ID) 
                                REFERENCES P_WASTE_CATEG(WC_ID),      
      CONSTRAINT 	P_REIMBURSED_PK      PRIMARY KEY(WC_ID)
      );

CREATE TABLE P_EPA_DOCS (
      EPADOC_ID     CHAR(5) 	        NOT NULL,
      FILENAME 	    VARCHAR2(50) 	    NULL,
      WC_ID         CHAR(5) 	        NOT NULL,
      CONSTRAINT 	P_EPA_DOCS_FK   FOREIGN KEY(WC_ID) 
                                REFERENCES P_EPA_WASTE(WC_ID),     
      CONSTRAINT 	P_EPA_DOCS_PK   PRIMARY KEY(EPADOC_ID),
      CONSTRAINT 	FILENAME_CHK    CHECK (UPPER(FILENAME) LIKE '_%.DOCX' OR UPPER(FILENAME) LIKE '_%.DOC' 
                                                   OR UPPER(FILENAME) LIKE '_%.PDF' OR  UPPER(FILENAME) LIKE '_%.TXT')
      );
