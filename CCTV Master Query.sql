-- Calculate flow direction based on to and from node inner join

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.flowDirection = 'Downstream'
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSEWERGRAVITYMAIN AS FLNSEWERGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSEWERGRAVITYMAIN.NODEFROM
		AND DPWCCTV_COPY.toNode = FLNSEWERGRAVITYMAIN.NODETO

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.flowDirection = 'Downstream'
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSTORMGRAVITYMAIN AS FLNSTORMGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSTORMGRAVITYMAIN.NODEFROM
		AND DPWCCTV_COPY.toNode = FLNSTORMGRAVITYMAIN.NODETO

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.flowDirection = 'Upstream'
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSEWERGRAVITYMAIN AS FLNSEWERGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSEWERGRAVITYMAIN.NODETO
		AND DPWCCTV_COPY.toNode = FLNSEWERGRAVITYMAIN.NODEFROM

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.flowDirection = 'Upstream'
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSTORMGRAVITYMAIN AS FLNSTORMGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSTORMGRAVITYMAIN.NODETO
		AND DPWCCTV_COPY.toNode = FLNSTORMGRAVITYMAIN.NODEFROM

-- Import FacilityID from Gravity Main Layers

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.pipeFacilityID = FLNSEWERGRAVITYMAIN.FACILITYID
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSEWERGRAVITYMAIN AS FLNSEWERGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSEWERGRAVITYMAIN.NODEFROM
		AND DPWCCTV_COPY.toNode = FLNSEWERGRAVITYMAIN.NODETO

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.pipeFacilityID = FLNSTORMGRAVITYMAIN.FACILITYID
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSTORMGRAVITYMAIN AS FLNSTORMGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSTORMGRAVITYMAIN.NODEFROM
		AND DPWCCTV_COPY.toNode = FLNSTORMGRAVITYMAIN.NODETO

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.pipeFacilityID = FLNSEWERGRAVITYMAIN.FACILITYID
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSEWERGRAVITYMAIN AS FLNSEWERGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSEWERGRAVITYMAIN.NODETO
		AND DPWCCTV_COPY.toNode = FLNSEWERGRAVITYMAIN.NODEFROM

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.pipeFacilityID = FLNSTORMGRAVITYMAIN.FACILITYID
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSTORMGRAVITYMAIN AS FLNSTORMGRAVITYMAIN
       ON DPWCCTV_COPY.fromNode = FLNSTORMGRAVITYMAIN.NODETO
		AND DPWCCTV_COPY.toNode = FLNSTORMGRAVITYMAIN.NODEFROM

-- Node Mismatch QA

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.QAnodeMismatch = 'Yes'
	WHERE DPWCCTV_COPY.flowDirection is null

-- Missing Location

UPDATE DPWCCTV_COPY
SET MissingLocation = 'Yes'
WHERE featureDescription IS NOT NULL AND featureLocationFT IS NULL

--Input streets to CCTV table

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.StreetName = sewerMain.STREET
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSEWERGRAVITYMAIN AS sewerMain
	ON DPWCCTV_COPY.pipeFacilityID = sewerMain.FACILITYID

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.StreetName = stormMain.STREET
FROM gisDEVviewer.DPWCCTV_COPY AS DPWCCTV_COPY
INNER JOIN FLNSTORMGRAVITYMAIN AS stormMain
	ON DPWCCTV_COPY.pipeFacilityID = stormMain.FACILITYID


--Input Utility based on to and from node ID prefixes

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Storm'
WHERE DPWCCTV_COPY.fromNode LIKE 'DMH%'

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Storm'
WHERE DPWCCTV_COPY.toNode LIKE 'DMH%'

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Storm'
WHERE DPWCCTV_COPY.fromNode LIKE 'CB%'

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Storm'
WHERE DPWCCTV_COPY.toNode LIKE 'CB%'

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Sewer'
WHERE DPWCCTV_COPY.fromNode LIKE 'SMH%'

UPDATE DPWCCTV_COPY
SET DPWCCTV_COPY.Utility = 'Sewer'
WHERE DPWCCTV_COPY.toNode LIKE 'SMH%'








-- Replaces cells that have null pipe lengths with lengths entered within the column for the same line segment

UPDATE gisDEVviewer.DPWCCTV_COPY
SET TotalPipeSegmentLengthFT = ROUND(blah.maxl, 2)
FROM gisDEVviewer.DPWCCTV_COPY AS a
INNER JOIN
(SELECT MAX(TotalPipeSegmentLengthFT) AS maxl, pipeFacilityID 
FROM gisDEVviewer.DPWCCTVREPORT 
WHERE TotalPipeSegmentLengthFT IS NOT NULL AND pipeFacilityID IS NOT NULL
GROUP BY pipeFacilityID
) AS blah
ON a.pipeFacilityID=blah.pipeFacilityID
WHERE TotalPipeSegmentLengthFT IS NULL AND a.pipeFacilityID IS NOT NULL


/*

-- Creates/alters a view of all the sewer lines referenced in the CCTV table

ALTER VIEW gisDEVviewer.evwDPWcctvSewerLine as

SELECT 
--ROW_NUMBER() OVER ( ORDER BY sewerMain.objectid) as OBJECTID,
sewerMain.OBJECTID as OID,
unionTable.*,
sewerMain.shape as shape
from (

SELECT DISTINCT
CCTV.flowDirection,
fromNode,
toNode,
condition
from
gisDEVviewer.DPWCCTVREPORT as CCTV

inner join gisDEVviewer.FLNSEWERGRAVITYMAIN as sewerMain
on fromNode = sewerMain.NODEFROM and toNode = sewerMain.NODETO 
where CCTV.flowDirection ='Downstream'
group by 
flowDirection, 
fromNode,
toNode,
Condition

UNION all
SELECT DISTINCT
CCTV.flowDirection,
fromNode,
toNode,
condition

from
gisDEVviewer.DPWCCTVREPORT as CCTV

inner join gisDEVviewer.FLNSEWERGRAVITYMAIN as sewerMain
on CCTV.toNode = sewerMain.NODEFROM and CCTV.fromNode = sewerMain.NODETO
where CCTV.flowDirection ='Upstream'
group by 
CCTV.flowDirection,
CCTV.fromNode,
CCTV.toNode,
CCTV.Condition
) 

unionTable


inner join gisDEVviewer.FLNSEWERGRAVITYMAIN as sewerMain
on (toNode = sewerMain.NODEFROM and fromNode = sewerMain.NODETO) or (fromNode = sewerMain.NODEFROM and toNode = sewerMain.NODETO)



--Creates/alters a view of all the points along sewer lines referenced in the table

ALTER VIEW gisDEVviewer.evwDPWcctvSewerPoint as

SELECT
unionTable.* 
FROM  
(

SELECT 
ROW_NUMBER() OVER ( ORDER BY Downstream.objectid desc) AS [OBJECTID]
,Downstream.OBJECTID AS [OID]
,Downstream.flowDirection AS [flowDirection]
,Downstream.fromNode AS [fromNode]
,Downstream.toNode AS [toNode]
,Downstream.condition AS [condition]
,Downstream.featureDescription AS [featureDescription]
,Downstream.featureLocationFT AS [featureLocationFT]
,Downstream.featureRepairDesc AS [featureRepairDesc]
,sewermain.shape.STIntersection((select  sewermain.shape.STStartPoint().STBuffer(ISNULL(Downstream.featureLocationFT,0)).STBoundary())) as [SHAPE] 
FROM
GISDEVVIEWER.dpwCCTV_copy Downstream
INNER JOIN
gisDEVviewer.flnsewerGravityMain AS sewermain
ON 
(fromNode=sewermain.NODEFROM and toNode=sewermain.NODETO)

UNION ALL

SELECT 
ROW_NUMBER() OVER ( ORDER BY Upstream.objectid desc) as [OBJECTID]
,Upstream.OBJECTID AS [OID]
,Upstream.flowDirection AS [flowDirection]
,Upstream.fromNode AS [fromNode]
,Upstream.toNode AS [toNode]
,Upstream.condition AS [condition]
,Upstream.featureDescription AS [featureDescription]
,Upstream.featureLocationFT AS [featureLocationFT]
,Upstream.featureRepairDesc AS [featureRepairDesc]
,sewermain1.shape.STIntersection((select  sewermain1.shape.STEndPoint().STBuffer(ISNULL(Upstream.featureLocationFT,0)).STBoundary())) as [SHAPE] 
FROM
GISDEVVIEWER.dpwCCTV_copy Upstream
inner join 
gisDEVviewer.flnsewerGravityMain sewermain1
on 
(toNode=sewermain1.NODEFROM and fromNode=sewermain1.NODETO) 

) AS unionTable



--Creates/alters a view of all the storm lines referenced in the table

ALTER VIEW gisDEVviewer.evwDPWcctvStormLine as

SELECT 
--ROW_NUMBER() OVER ( ORDER BY sewerMain.objectid) as OBJECTID,
stormMain.OBJECTID as OID,
unionTable.*,
stormMain.shape as shape
from (

SELECT DISTINCT
CCTV.flowDirection,
fromNode,
toNode,
condition
from
gisDEVviewer.DPWCCTVREPORT as CCTV

inner join gisDEVviewer.FLNSTORMGRAVITYMAIN as stormMain
on fromNode = stormMain.NODEFROM and toNode = stormMain.NODETO 
where CCTV.flowDirection ='Downstream'
group by 
flowDirection, 
fromNode,
toNode,
Condition

UNION all
SELECT DISTINCT
CCTV.flowDirection,
fromNode,
toNode,
condition

from
gisDEVviewer.DPWCCTVREPORT as CCTV

inner join gisDEVviewer.FLNSTORMGRAVITYMAIN as stormMain
on CCTV.toNode = stormMain.NODEFROM and CCTV.fromNode = stormMain.NODETO
where CCTV.flowDirection ='Upstream'
group by 
CCTV.flowDirection,
CCTV.fromNode,
CCTV.toNode,
CCTV.Condition
) 

unionTable


inner join gisDEVviewer.FLNSTORMGRAVITYMAIN as stormMain
on (toNode = stormMain.NODEFROM and fromNode = stormMain.NODETO) or (fromNode = stormMain.NODEFROM and toNode = stormMain.NODETO)


--Creates/alters a view of all the points along storm lines referenced in the table

alter view gisDEVviewer.evwDPWcctvStormPoint as

select * from  (

SELECT 
ROW_NUMBER() OVER ( ORDER BY stream.objectid desc) as OBJECTID
,stream.OBJECTID AS OID
,stream.flowDirection
,fromNode
,toNode
,condition
,stream.featureDescription
,stream.featureLocationFT
,stream.featureRepairDesc
,b.shape.STIntersection((select  b.shape.STStartPoint().STBuffer(ISNULL(stream.featureLocationFT,0)).STBoundary())) as shape 
FROM
GISDEVVIEWER.dpwCCTV_copy stream
inner join gisDEVviewer.flnstormGravityMain b
on (fromNode=b.NODEFROM and toNode=b.NODETO)

union all

SELECT 
ROW_NUMBER() OVER ( ORDER BY stream.objectid desc) as OBJECTID
,stream.OBJECTID AS OID
,stream.flowDirection
,fromNode
,toNode
,condition
,stream.featureDescription
,stream.featureLocationFT
,stream.featureRepairDesc
,b.shape.STIntersection((select  b.shape.STEndPoint().STBuffer(ISNULL(stream.featureLocationFT,0)).STBoundary())) as shape 
FROM
GISDEVVIEWER.dpwCCTV_copy stream
inner join gisDEVviewer.flnstormGravityMain b
on (toNode=b.NODEFROM and fromNode=b.NODETO) 

) t1

*/


/* 

--Derives NASSCO Code from described issues
--Run the following 'SELECT DISTINCT' when new data is received, and reference NASSCO code lookup table in Google Drive to input matches into the code where necessary

--SELECT DISTINCT nasscoCode, featureDescription FROM DPWCCTV_COPY as CCTV

UPDATE DPWCCTV_COPY
SET nasscoCode = 'ISSRB'
WHERE featureDescription like '&Broken Pipe%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'TB'
WHERE featureDescription like '%Tap%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'BM'
WHERE featureDescription like '%Buried Manhole%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'TFI'
WHERE featureDescription like '%Intruding Tap%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'MWES'
WHERE featureDescription like '%Pipe Sag%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'JOMD'
WHERE featureDescription like '%Realign%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'OBZ'
WHERE featureDescription like '%Roots%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'FL'
WHERE featureDescription like '%Pipe Fractures%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'RPPD'
WHERE featureDescription like '%Defective Patch%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'MMC'
WHERE featureDescription like '%Material Change%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'DAGS'
WHERE featureDescription like '%Grease%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'H'
WHERE featureDescription like '%Heavy Cleaning%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'JOM'
WHERE featureDescription like '%Offset Joint%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'TFC'
WHERE featureDescription like '%Capped Tap%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'TFD'
WHERE featureDescription like '%Defective Tap%'

UPDATE DPWCCTV_COPY
SET nasscoCode = 'OBZ'
WHERE featureDescription like '%Obstruction%'

UPDATE DPWCCTV_COPY
SET featureRepairDesc = 'Replace'
WHERE featureDescription like '%Replace%'

UPDATE DPWCCTV_COPY
SET featureRepairDesc = 'Repair Needed'
WHERE featureDescription like '%Repair%'

*/

/*

-- Derives other fields from notes field 
UPDATE DPWCCTV_COPY
SET surveyAbandoned = 'Yes'
WHERE NOTES LIKE '%Survey abandoned%' OR NOTES LIKE '%did not allow for completion%'

UPDATE DPWCCTV_COPY
SET materialChange = 'RCP'
WHERE NOTES LIKE '%Material change%'AND NOTES LIKE '%to RCP%'

UPDATE DPWCCTV_COPY
SET Condition = 'Fair'
WHERE NOTES LIKE '%No major defects%' OR NOTES LIKE '%acceptable%'

UPDATE DPWCCTV_COPY
SET Condition = 'Good'
WHERE NOTES LIKE '%No defects%' OR NOTES LIKE '%good%'

/*

--Synthesizes notes field based on described issues
--Run the following 'SELECT DISTINCT' when new data is received, and reference the input table to synthesize matches into the code where necessary

--SELECT DISTINCT Notes FROM DPWCCTV_COPY



UPDATE DPWCCTV_COPY
SET Notes = 'Roots'
WHERE NOTES LIKE '%Roots%'

UPDATE DPWCCTV_COPY
SET Notes = 'Minor roots'
WHERE NOTES LIKE '%Minor roots%'

UPDATE DPWCCTV_COPY
SET Notes = 'Broken Pipe'
WHERE NOTES LIKE '%Broken Pipe%'

UPDATE DPWCCTV_COPY
SET Notes = 'Broken pipe'
WHERE NOTES LIKE '%Broken%'

UPDATE DPWCCTV_COPY
SET Notes = 'Crack circumferential'
WHERE NOTES LIKE '%Crack circumferential%'

UPDATE DPWCCTV_COPY
SET Notes = 'Single crack'
WHERE NOTES = 'Crack found'

UPDATE DPWCCTV_COPY
SET Notes = 'Multiple cracks'
WHERE NOTES LIKE '%Crack multiple%' OR NOTES LIKE '%Cracks%'

UPDATE DPWCCTV_COPY
SET Notes = 'Minor crack'
WHERE NOTES LIKE '%Minor crack%'

UPDATE DPWCCTV_COPY
SET Notes = 'Grease'
WHERE NOTES LIKE '%Grease%'

UPDATE DPWCCTV_COPY
SET Notes = 'Fracture'
WHERE NOTES LIKE '%fracture found%'

UPDATE DPWCCTV_COPY
SET NOTES = 'Small fracture'
WHERE NOTES LIKE '%Small fracture%'

UPDATE DPWCCTV_COPY
SET Notes = 'Fracture circumferential'
WHERE NOTES LIKE '%Fracture circumferential%'

UPDATE DPWCCTV_COPY
SET Notes = 'Fracture longitudinal'
WHERE NOTES LIKE '%Fracture longitudinal%'

UPDATE DPWCCTV_COPY
SET Notes = 'Multiple fractures'
WHERE NOTES LIKE '%Fracture multiple%' OR NOTES LIKE '%Fractures%'

UPDATE DPWCCTV_COPY
SET Notes = 'Spiral fracture'
WHERE NOTES LIKE '%Fracture spiral%'

UPDATE DPWCCTV_COPY
SET Notes = 'Minor Fractures'
WHERE NOTES LIKE '%Minor fractures%'

UPDATE DPWCCTV_COPY
SET Notes = 'Hole'
WHERE NOTES LIKE '%Hole%'

UPDATE DPWCCTV_COPY
SET Notes = 'Small break'
WHERE NOTES LIKE '%Small break%'

UPDATE DPWCCTV_COPY
SET Notes = 'Infiltration'
WHERE NOTES LIKE '%Infiltration%'

UPDATE DPWCCTV_COPY
SET Notes = 'Infiltration runner'
WHERE NOTES LIKE '%Infiltration runner%'

UPDATE DPWCCTV_COPY
SET Notes = 'Infiltration tap break-in'
WHERE NOTES LIKE '%Infiltration - Tapbreak in%' OR NOTES LIKE '%Infiltration - tap%'

UPDATE DPWCCTV_COPY
SET Notes = 'Minor infiltration'
WHERE NOTES LIKE '%Minor infiltration%'

UPDATE DPWCCTV_COPY
SET Notes = 'Intruding tap'
WHERE NOTES LIKE '%Intruding tap%'

UPDATE DPWCCTV_COPY
SET Notes = 'Offset joint'
WHERE NOTES LIKE '%Offset joint%'

UPDATE DPWCCTV_COPY
SET Notes = 'Joint separation'
WHERE NOTES LIKE '%Joint separation%'

UPDATE DPWCCTV_COPY
SET Notes = 'Minor deformation'
WHERE NOTES LIKE '%Minor deformation'

UPDATE DPWCCTV_COPY
SET Notes = 'Rerouted main'
WHERE NOTES LIKE '%Main rerouted%'

UPDATE DPWCCTV_COPY
SET Notes = 'New manhole'
WHERE NOTES LIKE '%Manhole found%'

UPDATE DPWCCTV_COPY
SET Notes = 'Missing structure'
WHERE NOTES LIKE '%not on map%'

UPDATE DPWCCTV_COPY
SET Notes = 'Overflow protection pipe'
WHERE NOTES LIKE '%Overflow protection pipe%'

UPDATE DPWCCTV_COPY
SET Notes = 'Pipe sag'
WHERE NOTES LIKE '%Sag%' OR NOTES LIKE '%Sags%'

UPDATE DPWCCTV_COPY
SET Notes = 'Intruding tap'
WHERE NOTES LIKE '%Intruding tap%'

UPDATE DPWCCTV_COPY
SET Notes = 'Needs cleaning'
WHERE NOTES LIKE '%cleaning%'

UPDATE DPWCCTV_COPY
SET Notes = 'Debris'
WHERE NOTES LIKE '%debris%'

UPDATE DPWCCTV_COPY
SET NOTES = 'Defective repair patch'
WHERE NOTES LIKE '%Repair patch defective%'

UPDATE DPWCCTV_COPY
SET NOTES = 'Repair patch'
WHERE NOTES = 'Repair Patch'