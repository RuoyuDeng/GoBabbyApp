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

- Design and draw ER diagram from plain text requirements. Since it is a class project, I will not post the actual requirements here.
- Construct some tables to store the relations and entities in ER diagram with DB2 database system.
- Implement a light-weight, command-line program that retrieves information from the database.
