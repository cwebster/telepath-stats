<?php
	/*
	 * Script:    DataTables server-side script for PHP and MySQL
	 * Copyright: 2010 - Allan Jardine
	 * License:   GPL v2 or BSD (3-point)
	 */
	
	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	 * Easy set variables
	 */
	
	/* Array of database columns which should be read and sent back to DataTables. Use a space where
	 * you want to insert a non-database field (for example a counter or static image)
	 */
	$aColumns = array( 'Specimen_Number', 'Namespace', 'Consultant', 'Location', 'Registration_Number','Set_Exp','Record_State','Date_Time_Booked_In','Result_Set_Row_ID','HrsIn');
	
	/* Indexed column (used for fast and accurate table cardinality) */
	$sIndexColumn = "dri.Specimen_Number";
	
	
	/* Database connection information */
	$gaSql['user']       = "tpathhrt";
	$gaSql['password']   = "tpathhrt";
	$gaSql['db']         = "HRT";
	$gaSql['server']     = "GH";
	
	
	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	 * If you just want to use the basic configuration for DataTables with PHP server-side, there is
	 * no need to edit below this line
	 */
	
	/* 
	 * Cache ODBC connection
	 */
	$gaSql=  odbc_connect( $gaSql['server'], $gaSql['user'], $gaSql['password']  ) or
		die( 'Could not open connection to server' );
	
	
	/*
	 * SQL queries
	 * Get data to display
	 */
	$sQuery = "
SELECT
	count(*) as counter, dri.Specimen_Number,dri.Namespace,r.Consultant,r.Location,
	p.Registration_Number,s.Set_Exp,rs.Record_State, dri.Date_Received, rs.Result_Set_Row_ID, rs.Set_Code, rs.Date_Time_Booked_In,
	r.Date_Time_Received, (DATEDIFF('mi',rs.Date_Time_Booked_In,CURRENT_TIMESTAMP)) as HrsIn
FROM
	iLabTP.Date_Received_Index dri,iLabTP.Request r,iLabTP.Patient p,iLabTP.Result_Set rs, iLabTP.Ref_Set s
WHERE 
	datediff('hh',dri.Date_received,dateadd(dd,-1,Current_date)) < 7 AND
	dri.Request_Row_ID =r.Request_Row_ID AND
	r.Patient_Row_ID = p.patient_row_id AND
	s.Set_Row_ID = rs.Set_Row_ID AND
	r.Location in ('AMU1','AMU2') AND
	dri.Namespace <>'BBSHRT' AND
	dri.Request_Row_ID = rs.Request_Row_ID AND
	rs.Record_State not like 'A%'
Order by HrsIn 
	";
	
	$rResult = odbc_do($gaSql, $sQuery ) or die(odbc_error());

	$count=0;

	/*
	 * Output
	 */

	
	
	while ( $aRow = odbc_fetch_array( $rResult ) )
	{
		$row = array();
		for ( $i=0 ; $i<count($aColumns) ; $i++ )
		{
			if ( $aColumns[$i] == "version" )
			{
				/* Special output formatting for 'version' column */
				$row[] = ($aRow[ $aColumns[$i] ]=="0") ? '-' : $aRow[ $aColumns[$i] ];
			}
			else if ( $aColumns[$i] != ' ' )
			{
				/* General output */
				$row[] = $aRow[ $aColumns[$i] ];
			}
		}
		$output['aaData'][] = $row;
		$count++;
	}
	
//		$output1 = array(
//		"sEcho" => intval($_GET['sEcho']),
//		"iTotalRecords" => $count,
//		"iTotalDisplayRecords" => $count,
//		"aaData" => array()
//	);
	
	// $jsonOutput = array_merge($output1,$output);
    //echo json_encode( $jsonOutput );
    
    echo json_encode($output);
?>


