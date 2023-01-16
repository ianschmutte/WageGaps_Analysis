/*various formats useful for working with RAIS data
Ian M. Schmutte
6 Sept 2019
*/

proc format;
    /*from 2-digit sector to major industry based on CNAE20*/
	value $ indmjr
        '01'-'03' = 'A'
        '05'-'09' = 'B'		
        '10'-'33' = 'C'		
        '35'-'35' = 'D'		
        '36'-'39' = 'E'	
        '41'-'43' = 'F'		
        '45'-'47' = 'G'		
        '49'-'53' = 'H'		
        '55'-'56' = 'I'		
        '58'-'63' = 'J'		
        '64'-'66' = 'K'		
        '68'-'68' = 'L'		
        '69'-'75' = 'M'		
        '77'-'82' = 'N'		
        '84'-'84' = 'O'		
        '85'-'85' = 'P'		
        '86'-'88' = 'Q'		
        '90'-'93' = 'R'		
        '94'-'96' = 'S'		
        '97'-'97' = 'T'		
        '99'-'99' = 'U'
        OTHER = 'X'
        ;

    value $ indmjr_name
        'A'   = 'AGRICULTURE, LIVESTOCK, FOREST PRODUCTION, FISHING AND AQUACULTURE'
        'B'   =	'EXTRACTIVE INDUSTRIES'	
        'C'   =	'TRANSFORMATION INDUSTRIES'	
        'D'   =	'ELECTRICITY AND GAS'	
        'E'   =	'WATER, SEWAGE, WASTE MANAGEMENT AND DECONTAINATION ACTIVITIES'
        'F'   =	'CONSTRUCTION'	
        'G'   =	'TRADE; REPAIR OF MOTORCYCLE AND MOTORCYCLE VEHICLES'	
        'H'   =	'TRANSPORT, STORAGE AND MAIL'	
        'I'   =	'ACCOMMODATION AND FOOD'	
        'J'   =	'INFORMATION AND COMMUNICATION'	
        'K'   =	'FINANCIAL, INSURANCE AND RELATED SERVICES'	
        'L'   =	'REAL ESTATE ACTIVITIES'	
        'M'   =	'PROFESSIONAL, SCIENTIFIC AND TECHNICAL ACTIVITIES'	
        'N'   =	'ADMINISTRATIVE ACTIVITIES AND ADDITIONAL SERVICES'	
        'O'   =	'PUBLIC ADMINISTRATION, DEFENSE AND SOCIAL SECURITY'	
        'P'   =	'EDUCATION'	
        'Q'   =	'HUMAN HEALTH AND SOCIAL SERVICES'	
        'R'   =	'ARTS, CULTURE, SPORT AND RECREATION'	
        'S'   =	'OTHER SERVICE ACTIVITIES'	
        'T'   =	'DOMESTIC SERVICES'	
        'U'   = 'INTERNATIONAL ORGANIZATIONS AND OTHER EXTRATERRITORY INSTITUTIONS '
        'X'   = 'Missing'
        ;	

    value  educ_name
        OTHER = 'Missing'
        1 = 'Illiterate'
        2 = 'Some elementary'
        3 = 'Elemenary (yr 5)'
        4 = 'Some middle school'
        5 = 'Middle school (yr 9)'
        6 = 'Some high school'
        7 = 'High school (yr 12)'
        8 = 'Some college'
        9 = 'College or more'
    ;

	value occsm_name 
	    OTHER = 'Missing'
	    0  = 'Military'
	    1  = 'Public Administration and Management'
	    2  = 'Professionals, Artists, and Scientists'
	    3  = 'Mid-level Technicians'
	    4  = 'Administrative Workers'
	    5  = 'Service Workers and Vendors'
	    6  = 'Agriculture Workers, Fishermen, Forestry Workers'
	    7  = 'Production I'
	    8  = 'Production II'
	    9  = 'Repair and Maintenence Workers';

	value $ reg
		"1" = 'North'
		"2" = 'Northeast'
		"3" = 'Southeast'
		"4" = 'South'
		"5" = 'Central-West';
run;

	