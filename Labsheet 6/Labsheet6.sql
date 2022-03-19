USE DSDDA_Tute4

-- creating table
CREATE TABLE AdminDocs (
    id INT PRIMARY KEY,
    xDoc XML NOT NULL
)

-- inserting data
INSERT INTO AdminDocs VALUES (1,  
'<catalog> 
  <product dept="WMN"> 
    <number>557</number> 
    <name language="en">Fleece Pullover</name> 
    <colorChoices>navy black</colorChoices> 
  </product> 
  <product dept="ACC"> 
    <number>563</number> 
    <name language="en">Floppy Sun Hat</name> 
  </product> 
  <product dept="ACC"> 
    <number>443</number> 
    <name language="en">Deluxe Travel Bag</name> 
  </product> 
  <product dept="MEN"> 
    <number>784</number> 
    <name language="en">Cotton Dress Shirt</name> 
    <colorChoices>white gray</colorChoices> 
    <desc>Our <i>favorite</i> shirt!</desc> 
  </product> 
</catalog>') 

INSERT INTO AdminDocs VALUES (2,  
'<doc id="123"> 
    <sections> 
        <section num="1"><title>XML Schema</title></section> 
        <section num="3"><title>Benefits</title></section> 
        <section num="4"><title>Features</title></section> 
    </sections> 
</doc>')

-- Displaying all records in admic docs
SELECT *
FROM AdminDocs

-- xPath expressions -----------------------------------------------------------------
-- display all the products
SELECT id, xDoc.query('/catalog/product')
FROM AdminDocs

-- display all the products method 2
SELECT id, xDoc.query('//product')
FROM AdminDocs

-- display all the products without depending on the previous tags before product
SELECT id, xDoc.query('/*/product')
FROM AdminDocs

-- display all the products having dept attribute as WMN
SELECT id, xDoc.query('/*/product[@dept="WMN"]')
FROM AdminDocs

-- display all the products having dept attribute as WMN, standard way
SELECT id, xDoc.query('/*/child::product[attribute::dept="WMN"]')
FROM AdminDocs

-- display all the products having dept attribute as WMN
SELECT id, xDoc.query('//product[@dept="WMN"]')
FROM AdminDocs


SELECT id, xDoc.query('descendant-or-self::product[attribute::dept="WMN"]')
FROM AdminDocs

-- display all the products having number > 500
SELECT id, xDoc.query('//product[number > 500]')
FROM AdminDocs
WHERE id = 1

-- display all the numbers having number > 500
SELECT id, xDoc.query('//product/number[.gt 500]')
FROM AdminDocs
WHERE id = 1

-- display the product in the 4th index
SELECT id, xDoc.query('/catalog/product[4]')
FROM AdminDocs
WHERE id = 1

-- display all the products having number > 500 and dept attribute as ACC
SELECT id, xDoc.query('//product[number > 500][@dept = "ACC"]')
FROM AdminDocs
WHERE id = 1

-- display the product having number > 500 in the 1st index
SELECT id, xDoc.query('//product[number > 500][1]')
FROM AdminDocs
WHERE id = 1

-- XQuery ---------------------------------------------------------------------------
-- display numbers of each product
SELECT xDoc.query(' for $prod in //product
                    let $x := $prod/number
                    return $x')
FROM AdminDocs
WHERE id = 1

-- display numbers of each product having number > 500
SELECT xDoc.query(' for $prod in //product
                    let $x := $prod/number
                    where $x > 500
                    return $x')
FROM AdminDocs
WHERE id = 1

-- display numbers of each product having number > 500, enclosed in an item tag
SELECT xDoc.query(' for $prod in //product
                    let $x := $prod/number
                    where $x > 500
                    return (<Item>{$x}</Item>)')
FROM AdminDocs
WHERE id = 1

-- display numbers of each product having number > 500, enclosed in an item tag
SELECT xDoc.query(' for $prod in //product[number > 500]
                    let $x := $prod/number
                    return (<Item>{$x}</Item>)')
FROM AdminDocs
WHERE id = 1

-- display numbers of each product having number > 500, enclosed in an item tag without the number tag
SELECT xDoc.query(' for $prod in //product
                    let $x := $prod/number
                    where $x > 500
                    return (<Item>{data($x)}</Item>)')
FROM AdminDocs
WHERE id = 1

-- display numbers of each product where numbers > 500 enclosed in a book tag and otherwise in a paper tag
SELECT xDoc.query(' for $prod in //product
                    let $x := $prod/number
                    return 
                        if ($x > 500) then
                            <book>{data($x)}</book>
                        else
                            <paper>{data($x)}</paper>')
FROM AdminDocs
WHERE id = 1

-- XML DML XQuery ---------------------------------------------------------------------------
-- Displaying all records in admic docs id 2
SELECT *
FROM AdminDocs
WHERE id = 2

-- insert new section after the first section having num attribute as 1
UPDATE AdminDocs SET xDoc.modify('
    insert
        <section num = "2">
            <title>Background</title>
        </section>
    after(/doc//section[@num = 1])[1]')

-- delete section having the num attribute as 2
UPDATE AdminDocs SET xDoc.modify('
    delete  
        //section[@num="2"]') 