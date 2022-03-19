CREATE DATABASE DSDDA_Tute4
USE DSDDA_Tute4

DROP TABLE Planes

CREATE TABLE Planes ( 
  id int  primary key, 
  xText Xml not null
)

INSERT INTO Planes VALUES (1, 
'<?xml version="1.0" encoding="UTF-8"?> 
<planes> 
   <plane> 
      <year> 1977 </year> 
      <make> Cessna </make> 
      <model> Skyhawk </model> 
      <color> Light blue and white </color> 
   </plane> 
   <plane> 
      <year> 1975 </year> 
      <make> Piper </make> 
      <model> Apache </model> 
      <color> White </color> 
   </plane>    
   <plane> 
      <year> 1960 </year> 
      <make> Cessna </make> 
      <model> Centurian </model> 
      <color> Yellow and white </color> 
   </plane> 
   <plane> 
      <year> 1956 </year> 
      <make> Piper </make> 
      <model> Tripacer </model> 
      <color> Blue </color> 
   </plane> 
</planes>')

SELECT * FROM Planes

SELECT xText.query('let $planes := //plane
                     return 
                     <oldPlanes>
                     {
                        for $plane in $planes
                        where $plane/year < 1970
                        return ($plane/make, $plane/model)
                     }
                     </oldPlanes>')
FROM Planes

SELECT xText.query('let $planes := /planes/plane
                    return 
                    <results>
                    {
                        for $x in $planes
                        where $x/year >= 1970
                        order by ($x/year)[1]
                        return ($/make, $x/model, $x/year)
                    }
                    </results>')
FROM Planes


SELECT xText.query('let $planes := //plane
                     return <table><tr><th>Model</th><th>Colour</th></tr>
                     {
                        for $x in $planes
                        return <tr><td>{data($x/model)}</td><td>{data($x/color)}</td></tr>
                     }
                     </table>')
FROM Planes