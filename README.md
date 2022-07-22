# GoBabbyApp

## Quick Note

==This application does not work now due to limited access to the school database server. If you want to try it out on your machine, you must have access to another valid server with DB2 database==

Please fill in the following information from line `24-27` in `GoBabbyApp.java` in order to run the code. Make sure the server you entered do have a valid DB2 database running.

```java
String url = "jdbc:db2://<your_server>";
String your_userid = "<your_userid>";
String your_password = "<your_password>";
```



## What is this?

- A simple program that retrieves information stored in the database. The information is stored in tables.



## What did I do?

- First,I design and draw ER diagram from plain text requirements. Since it is a class project, I will not post the full requirements here. I quote a small clip from the original requirement to give you a sense of how the text is like: 
  > A midwife is associated with either a community clinic or a birthing center (the latter has additional facilities to give
  birth at the center, unlike the former). The system you build should also keep track of the midwife's name, email,
  phone number, and practitioner id........
- Then, I construct some tables with SQL to store the relations and entities in ER diagram with DB2 database system. (see `create-load-drop_tables_code` for details)
- Lastly, I implement a light-weight, command-line program that retrieves information from the database.
