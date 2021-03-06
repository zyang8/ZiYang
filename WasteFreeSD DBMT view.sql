CREATE VIEW P_WC_NEEDS_REVIEW_V AS 
SELECT WC_ID,WC_DESC,DATE_ADDED,ROUND((SYSDATE-DATE_ADDED)/365,1) AS YEARS_SINCE_ADDED,ROUND((SYSDATE-DATE_REVIEWED)/365,1) AS YEARS_SINCE_REVIEW
FROM P_WASTE_CATEG
WHERE DATE_REVIEWED IS NULL AND (SYSDATE-DATE_ADDED)/365 > 5 OR DATE_REVIEWED IS NOT NULL AND (SYSDATE-DATE_ADDED)/365 > 5;

CREATE VIEW P_MOST_CENTRAL_DROPOFF_SITES_V AS
SELECT P_RECYCLING_ORG.ORG_NAME,P_DO_SITE.SITE_NUM,P_DO_SITE.SITE_STREET1,P_DO_SITE.SITE_CITY,P_DO_SITE.SITE_ZIP,ROUND(AVG(P_DISTANCE.DISTANCE_MILES),2) AS AVERAGE_MILES_TO_DISTICTS
FROM P_RECYCLING_ORG,P_DO_SITE,P_DISTANCE,P_CITY_LOCATION
WHERE P_CITY_LOCATION.LOCATION_ID = P_DISTANCE.LOC_ID
    AND P_DO_SITE.ORG_ID = P_DISTANCE.ORG_ID
    AND P_DO_SITE.SITE_NUM = P_DISTANCE.SITE_NUM
    AND P_RECYCLING_ORG.ORG_ID = P_DO_SITE.ORG_ID
GROUP BY P_RECYCLING_ORG.ORG_NAME,P_DO_SITE.SITE_NUM,P_DO_SITE.SITE_STREET1,P_DO_SITE.SITE_CITY,P_DO_SITE.SITE_ZIP
HAVING AVG(DISTANCE_MILES)<8
ORDER BY AVG(P_DISTANCE.DISTANCE_MILES);

CREATE VIEW P_WC_MISSING_FROM_SUBTYPES_V AS
SELECT WC_ID, WC_DESC, WASTETYPE
FROM P_WASTE_CATEG 
WHERE (P_WASTE_CATEG.WASTETYPE = 'E' OR P_WASTE_CATEG.WASTETYPE = 'R')
      AND  P_WASTE_CATEG.WC_ID NOT IN ((SELECT WC_ID FROM P_EPA_WASTE) UNION (SELECT WC_ID FROM P_REIMBURSED)); 
      
CREATE VIEW P_WE_BUY_V AS 
SELECT ('We buy'|| P_WASTE_CATEG.WC_DESC || 'at $' || P_REIMBURSED.PRICE_PER_LB || 'per pound.') AS WE_BUY_MESSAGE
FROM P_WASTE_CATEG, P_REIMBURSED
WHERE P_WASTE_CATEG.WC_ID = P_REIMBURSED.WC_ID;

CREATE VIEW P_ALL_WASTE_CATGE_V AS
SELECT * 
FROM P_DO_SITE
WHERE NOT EXISTS
    (SELECT * 
     FROM P_WASTE_CATEG 
     WHERE NOT EXISTS
        (SELECT * 
         FROM P_DO_SITE_WC_INT
         WHERE P_DO_SITE.ORG_ID = P_DO_SITE_WC_INT.ORG_ID 
            AND P_WASTE_CATEG.WC_ID = P_DO_SITE_WC_INT.WC_ID 
            AND P_DO_SITE.SITE_NUM = P_DO_SITE_WC_INT.DO_SITENUM));

CREATE VIEW P_GASLAMP_ALUM_DISTANCES_V AS
SELECT P_CITY_LOCATION.LOC_DESC,P_WASTE_CATEG.WC_DESC,P_DISTANCE.DISTANCE_MILES,P_DO_SITE.GPS_LAT,P_DO_SITE.GPS_LON,P_DO_SITE.SITE_STREET1,P_DO_SITE.SITE_STREET2,P_DO_SITE.SITE_CITY
FROM P_DISTANCE,P_CITY_LOCATION,P_DO_SITE,P_DO_SITE_WC_INT,P_WASTE_CATEG
WHERE P_CITY_LOCATION.LOCATION_ID = P_DISTANCE.LOC_ID 
    AND P_DISTANCE.ORG_ID = P_DO_SITE.ORG_ID 
    AND P_DISTANCE.SITE_NUM = P_DO_SITE.SITE_NUM 
    AND P_DO_SITE.ORG_ID = P_DO_SITE_WC_INT.ORG_ID 
    AND P_DO_SITE.SITE_NUM = P_DO_SITE_WC_INT.DO_SITENUM 
    AND P_DO_SITE_WC_INT.WC_ID = P_WASTE_CATEG.WC_ID 
    AND LOC_DESC = 'Gaslamp Quarter' 
    AND WC_DESC = 'Aluminum'
ORDER BY DISTANCE_MILES;
