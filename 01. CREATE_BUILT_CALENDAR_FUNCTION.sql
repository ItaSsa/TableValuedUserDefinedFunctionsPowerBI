
CREATE FUNCTION  FN_BUILT_CALENDAR
(
  @DATE_INI              DATE 
  ,@DATE_END             DATE 
)


RETURNS @T_CALENDAR TABLE
(

  [date] DATE PRIMARY KEY
, [year] INT
, [start_of_year] DATE
, [end_of_year] DATE
, [month] TINYINT
, [star_of_month] DATE
, [end_of_month] DATE
, [day_in_month] TINYINT
, [year_month_number] INT
, [year_month_name] VARCHAR(8)
, [day] TINYINT
, [day_name] VARCHAR(15)
, [day_name_short] CHAR(3)
, [day_of_week] TINYINT
, [day_of_year] SMALLINT
, [month_name] VARCHAR(15)
, [month_name_short] CHAR(3)
, [quarter] TINYINT
, [quarter_name] CHAR(2)
, [year_quarter_number] INT
, [year_quarter_name] VARCHAR(7)
, [start_of_quarter] DATE
, [end_of_quarter] DATE
, [week_of_year] TINYINT 
, [star_of_week] DATE
, [end_of_week] DATE
)

AS

BEGIN

	DECLARE @N_START  INT = 0
	DECLARE @N_END  INT = DATEDIFF( DAY , @DATE_INI , @DATE_END ) /* with the quantity of day to be generated */
	DECLARE @T_DATES TABLE ( F_DATE  DATE)


	WHILE @N_START <= @N_END
	BEGIN

		INSERT INTO @T_DATES ( F_DATE ) VALUES( DATEADD( DAY , @N_START , @DATE_INI )  )
		SET @N_START = @N_START + 1
	END
	
	INSERT INTO @T_CALENDAR
	( 
		 [date]
		, [year] 
		, [start_of_year] 
		, [end_of_year] 
		, [month] 
		, [star_of_month] 
		, [end_of_month] 
		, [day_in_month] 
		, [year_month_number] 
		, [year_month_name]
		, [day] 
		, [day_name]
		, [day_name_short]
		, [day_of_week]
		, [day_of_year]
		, [month_name]
		, [month_name_short]
		, [quarter]
		, [quarter_name]
		, [year_quarter_number]
		, [year_quarter_name]
		, [start_of_quarter]
		, [end_of_quarter]
		, [week_of_year]
		, [star_of_week]
		, [end_of_week]
	)
	SELECT A.F_DATE                                                                     AS [date]
		 , DATEPART( yy , A.F_DATE )                                                    AS [year]
		 , DATEFROMPARTS( YEAR( A.F_DATE ) , 1 , 1 )                                    AS [start_of_year]
		 , DATEFROMPARTS( YEAR( A.F_DATE ) , 12 , 31 )                                  AS [end_of_year]
		 , DATEPART( mm , A.F_DATE)                                                    AS [month]
		 , DATEFROMPARTS( YEAR( A.F_DATE ) , MONTH( A.F_DATE ) , 1 )                    AS [star_of_month]
		 , EOMONTH( A.F_DATE )                                                          AS [end_of_month]
		 , DATEPART( dd , EOMONTH( A.F_DATE ) )                                         AS [day_in_month]

		 , CONCAT( 
				YEAR( A.F_DATE ) , 
				CONCAT(
					REPLICATE( '0' , 2 - LEN( MONTH( A.F_DATE ) ) ) ,
					MONTH( A.F_DATE )
				)
		   )                                                                            AS [year_month_number]
	 
		 , CONCAT( 
				DATEPART( yy , A.F_DATE ) , 
				'-' ,  
				LOWER( LEFT( DATENAME( mm , A.F_DATE ) , 3 ) )  )                       AS [year_month_name]
	 
	 
		 , DATEPART( dd , A.F_DATE )                                                    AS [day]
		 , LOWER( DATENAME( dw , A.F_DATE ) )                                           AS [day_name]
		 , LOWER( LEFT( DATENAME( dw , A.F_DATE ) , 3 ) )                               AS [day_name_short]
		 , DATEPART( [weekday] , A.F_DATE )                                             AS [day_of_week]
		 , DATEPART( dy , A.F_DATE )                                                    AS [day_of_year]
		 , LOWER( DATENAME( mm , A.F_DATE ) )                                           AS [month_name]
		 , LOWER( LEFT( DATENAME( mm , A.F_DATE ) , 3 ) )                               AS [month_name_short]
		 , DATEPART( qq , A.F_DATE )                                                    AS [quarter]
		 , CONCAT( 'Q' , DATEPART( qq , A.F_DATE ) )                                    AS [quarter_name]
		 , CONCAT( DATEPART( yy , A.F_DATE ) , DATEPART( qq , A.F_DATE ) )              AS [year_quarter_number]
		 , CONCAT( DATEPART( yy , A.F_DATE ) , ' Q' , DATEPART( qq , A.F_DATE ) )       AS [year_quarter_name]
		 , DATEFROMPARTS( YEAR( A.F_DATE ), (DATEPART( qq , A.F_DATE )*3)-2, 1)         AS [start_of_quarter]
		 , EOMONTH( DATEFROMPARTS( YEAR( A.F_DATE ), (DATEPART( qq , A.F_DATE ))*3, 1),0) AS [end_of_quarter]
		 , DATEPART( wk , A.F_DATE )                                                    AS [week_of_year]
		 , DATEADD( DAY , - ( DATEPART( [weekday] , A.F_DATE ) - 1 ) , A.F_DATE )       AS [star_of_week]
		 , DATEADD( DAY , 7 - DATEPART( [weekday] , A.F_DATE ) , A.F_DATE )             AS [end_of_week]
	  FROM @T_DATES  A
		ORDER BY 1

RETURN


END