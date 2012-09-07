<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>AMU Outstanding Work</title>
	<meta name="generator" content="BBEdit 10.1" />
</head>
<body>

<?php

putenv("LD_LIBRARY_PATH=/usr/local/lib");  //This may be blocked by php security

echo $LD_LIBRARY_PATH;

//putenv("ODBCINSTINI=/path/to/odbcinst.ini"); //this location will be determined by your driver install.

//putenv("ODBCINI=/path/to/odbc.ini"); //odbc.ini contains your DSNs, location determined by your driver install.

$dsn="GH"; 

$user="tpathhrt"; 

$password="tpathhrt"; 

 

$sql="
SELECT
	dri.Specimen_Number,dri.Namespace,r.Consultant,r.Location,
	p.Registration_Number,rs.Set_Code,rs.Record_State, dri.Date_Received
FROM
	iLabTP.Date_Received_Index dri,iLabTP.Request r,iLabTP.Patient p,iLabTP.Result_Set rs
WHERE 
	datediff('dd',dri.Date_received,dateadd(dd,-1,Current_date)) < 7 AND
	dri.Request_Row_ID =r.Request_Row_ID AND
	r.Patient_Row_ID = p.patient_row_id AND
	r.Location in ('AMU1','AMU2') AND
	dri.Request_Row_ID = rs.Request_Row_ID AND
	rs.Record_State not like 'A%'
";   

if ($conn_id=odbc_connect("$dsn","tpathhrt","tpathhrt")){

echo "connected to DSN: $dsn";

if($result=odbc_do($conn_id, $sql)) {

echo "executing '$sql'";

echo "Results: ";

odbc_result_all($result);

echo "freeing result";

odbc_free_result($result);

}else{

echo "can not execute '$sql' ";

}

echo "closing connection $conn_id";

odbc_close($conn_id);

}else{

echo "can not connect to DSN: $dsn ";

}

?>





</body>
</html>
