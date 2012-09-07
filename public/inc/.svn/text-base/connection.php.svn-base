<?php

putenv("LD_LIBRARY_PATH=/usr/local/lib");  //This may be blocked by php security

echo $LD_LIBRARY_PATH;

//putenv("ODBCINSTINI=/path/to/odbcinst.ini"); //this location will be determined by your driver install.

//putenv("ODBCINI=/path/to/odbc.ini"); //odbc.ini contains your DSNs, location determined by your driver install.

$dsn="GH"; 

$user="tpathhrt"; 

$password="tpathhrt"; 


if ($conn_id=odbc_connect("$dsn","tpathhrt","tpathhrt")){

echo "connected to DSN: $dsn";


}else{

echo "can not connect to DSN: $dsn ";

}

?>