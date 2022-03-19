drop table AdminDocs

-- Example: Untyped XML Column in Table

CREATE TABLE AdminDocs ( 
  id int  primary key, 
  xDoc Xml not null
)

-- Example: Inserting Data into Untyped XML Column

INSERT INTO AdminDocs VALUES (6, 
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

select * 
from AdminDocs

