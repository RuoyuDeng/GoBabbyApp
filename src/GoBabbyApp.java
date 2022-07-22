import java.sql.* ;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;

public class GoBabbyApp {

    private static String formSQLstr(String pInput){
        return "\'" + pInput + "\'";
    }
    public static void main(String[] args) throws SQLException {
        Scanner sc = new Scanner(System.in);
        String userInput = "";

        int sqlCode=0;      // Variable to hold SQLCODE
        String sqlState="00000";  // Variable to hold SQLSTATE

        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // connect to database
        String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";
        String your_userid = "rdeng4";
        String your_password = "dd991218";
        Connection con = null;
        boolean hasConnection = true;
        if(your_userid.equals("") || your_password.equals("")) {
            hasConnection = false;
            System.out.println("Can not set up connection. Check userid and passwd setup");
        }
        else con = DriverManager.getConnection(url,your_userid,your_password);

        boolean goBack = false;

        // MAIN LOOP
        mainloop:
        while(hasConnection){
            PreparedStatement prestat = null;
            System.out.print("Please enter your practitioner id, [E] to exit:");
            userInput = sc.nextLine();
            String mwid = userInput;
            String oldUserInput = userInput;
            String dateInput = null;
            java.sql.ResultSet rs = null;


            if(userInput.equals("E")) {
                // close up connections to database
                con.close();
                break;
            }
            try
            {
                String querySQL = "SELECT APPOINTID\n" +
                        "FROM MIDWIFE,APPOINTMENT,PREGNANCY\n" +
                        "WHERE (PREGNANCY.PRIMARYMWID = ? OR PREGNANCY.BACKUPMWID = ?)" +
                        "AND MIDWIFE.PARCID = APPOINTMENT.PARCID\n" +
                        "AND APPOINTMENT.COUPLEID = PREGNANCY.COUPLEID\n" +
                        "AND APPOINTMENT.NUMOFPREG = PREGNANCY.NUMOFPREG\n";
                prestat = con.prepareStatement(querySQL);
                prestat.setString(1,mwid);
                prestat.setString(2,mwid);
                rs = prestat.executeQuery();
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                break;
            }

            // No such record found, raise an error msg and continue
            assert rs != null;
            boolean hasRecord = rs.next();
            if(!hasRecord) {
                System.out.println("No appointment found with input practitioner id");
                continue;
            }
            // Appointment loop
            while(true){
                // found such record, displace new info based on date
                if(!goBack){
                    System.out.print("Please enter the date for appointment list, [E] to exit: ");
                    dateInput = sc.nextLine();
                    if(dateInput.equals("E")) {
                        prestat.close();
                        con.close();
                        rs.close();
                        break mainloop; // if need to exit the menu
                    }
                }
//                else userInput = oldUserInput;

                // execute SQL to get data
                try{
                    String querySQL = "SELECT APPOINTTIME,PRIMARYMWID,BACKUPMWID,MOTHER.MNAME," +
                            "COUPLE.MHEALTHID,APPOINTID,PREGNANCY.COUPLEID,PREGNANCY.NUMOFPREG\n" +
                            "FROM MIDWIFE,APPOINTMENT,PREGNANCY,COUPLE,MOTHER\n" +
                            "WHERE (PREGNANCY.PRIMARYMWID = ? OR PREGNANCY.BACKUPMWID = ?)\n" +
                            "AND APPOINTDATE = ?\n" +
                            "AND MIDWIFE.PARCID = APPOINTMENT.PARCID\n" +
                            "AND APPOINTMENT.COUPLEID = PREGNANCY.COUPLEID\n" +
                            "AND APPOINTMENT.NUMOFPREG = PREGNANCY.NUMOFPREG\n" +
                            "AND COUPLE.COUPLEID = PREGNANCY.COUPLEID\n" +
                            "AND COUPLE.MHEALTHID = MOTHER.MHEALTHID\n" +
                            "ORDER BY APPOINTTIME\n";
                    prestat = con.prepareStatement(querySQL);
                    prestat.setString(1,mwid);
                    prestat.setString(2,mwid);
                    prestat.setString(3,dateInput);
                    rs = prestat.executeQuery();
                }catch (SQLException e)
                {
                    sqlCode = e.getErrorCode(); // Get SQLCODE
                    sqlState = e.getSQLState(); // Get SQLSTATE
                    System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                    System.out.println(e);
                    break mainloop;
                }


                // no appointments found with such date, ask for another date
                boolean hasAppoint = rs.next();
                if(!hasAppoint){
                    System.out.println("No appointment found with input date, try another date");
                    continue;
                }
                // store all necessary info of the all mothers assigned to current midwife
                ArrayList<String> appointIDs = new ArrayList<>();
                ArrayList<String> coupleIDs = new ArrayList<>();
                ArrayList<Integer> numofPregs = new ArrayList<>();
                ArrayList<String> motherNames = new ArrayList<>();
                ArrayList<String> healthIDs = new ArrayList<>();


                // read all records of a given date using a loop
                while(hasAppoint){
                    Time time = rs.getTime(1);
                    String PorB = null;
                    String pmwid = rs.getString(2);
                    if(rs.wasNull()) pmwid = "";
                    String bmwid = rs.getString(3);
                    if(rs.wasNull()) bmwid = "";

                    if(mwid.equals(pmwid)) PorB = "P";
                    if(mwid.equals(bmwid)) PorB = "B";

                    String mname = rs.getString(4);
                    motherNames.add(mname);

                    String healthID = rs.getString(5);
                    healthIDs.add(healthID);
                    String appointID = rs.getString(6);
                    appointIDs.add(appointID);
                    int lineOfRecord = appointIDs.indexOf(appointID)+1;

                    String coupleID = rs.getString(7);
                    int numofPreg = rs.getInt(8);
                    coupleIDs.add(coupleID);
                    numofPregs.add(numofPreg);
                    System.out.println(lineOfRecord + ": " + time + " " + PorB + " " + mname + " " + healthID);
                    hasAppoint = rs.next();
                }


                System.out.print("Enter the appointment number that you would like to work on.\n" +
                        "[E] to exit [D] to go back to another date : ");
                userInput = sc.nextLine();
                if(userInput.equals("E")){
                    prestat.close();
                    rs.close();
                    con.close();
                    break mainloop;
                }
                else if(userInput.matches("[0-9]+")){
                    int recordIndex = Integer.parseInt(userInput)-1;
                    if(recordIndex >= appointIDs.size()) {
                        System.out.println("Invalid Option! Try another option");
                        goBack = true;
                        continue;
                    }

                    // get all necessary info of the current mother & pregnancy
                    String curAppointID = appointIDs.get(recordIndex);
                    String curCoupleID = coupleIDs.get(recordIndex);
                    String curMomName = motherNames.get(recordIndex);
                    String curHealthID = healthIDs.get(recordIndex);
                    int curNumofPreg = numofPregs.get(recordIndex);

                    // Provide choices for the current mother (modified by midwife)
                    while(true){
                        String msg = "For " + curMomName + " " + curHealthID +
                                "\n\n1. Review notes\n" +
                                "2. Review tests\n" +
                                "3. Add a note\n" +
                                "4. Prescribe a test\n" +
                                "5. Go back to the appointments.\n";
                        System.out.println(msg);
                        System.out.print("Enter your choice: ");
                        userInput = sc.nextLine();
                        if(!userInput.matches("[0-9]+")) {
                            System.out.println("Invalid Option! Try another option");
                            continue;
                        }
                        int optionNum = Integer.parseInt(userInput);

                        // Option 1
                        if(optionNum == 1){
                            // read notes related info for user GIVEN a appoint id
                            try{
                                String querySQL = "SELECT NOTETIMESTAMP,CONTENT\n" +
                                        "FROM Note,APPOINTMENT\n" +
                                        "WHERE NOTE.APPOINTID = APPOINTMENT.APPOINTID\n" +
                                        "AND APPOINTMENT.APPOINTID = ?\n";
                                prestat = con.prepareStatement(querySQL);
                                prestat.setString(1,curAppointID);
                                rs = prestat.executeQuery();

                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }
                            hasRecord = rs.next();
                            if(!hasRecord) {
                                System.out.println("No notes exist for this appointment! Try another option");
                                continue;
                            }
                            // read all notes record for an appointment
                            while(hasRecord){
                                Timestamp timesp = rs.getTimestamp(1);
                                String content = rs.getString(2);
                                System.out.println(timesp + " " + content);
                                hasRecord = rs.next();
                            }
                        }

                        // Option 2
                        else if (optionNum == 2){
                            // read notes related info for user GIVEN a appoint id
                            try{
                                String querySQL = "SELECT PRESCDATE,TESTTYPE,TESTRESULT\n" +
                                        "FROM MEDICALTEST\n" +
                                        "WHERE MEDICALTEST.COUPLEID = ?\n" +
                                        "AND MEDICALTEST.NUMOFPREG = ?\n" +
                                        "AND MEDICALTEST.BABYID IS NULL";
                                prestat = con.prepareStatement(querySQL);
                                prestat.setString(1,curCoupleID);
                                prestat.setInt(2,curNumofPreg);
                                rs = prestat.executeQuery();

                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }
                            hasRecord = rs.next();
                            if(!hasRecord) {
                                System.out.println("No tests exist for this appointment! Try another option");
                                continue;
                            }
                            // read all notes record for an appointment
                            while(hasRecord){
                                Date prescdate = rs.getDate(1);
                                String testType = rs.getString(2);
                                String testResult = rs.getString(3);
                                System.out.println(prescdate + " [" + testType + "] " + testResult);
                                hasRecord = rs.next();
                            }
                        }


                        // Option 3
                        else if (optionNum == 3){
                            int numofNote = 0;
                            int newNoteID = 0;
                            // generate a new note id based on previous records of notes in database
                            try{
                                String querySQL = "SELECT COUNT(NOTEID) FROM NOTE";
                                prestat = con.prepareStatement(querySQL);
                                rs = prestat.executeQuery();

                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }

                            hasRecord = rs.next();
                            if(!hasRecord){
                                newNoteID = 5000;
                            }
                            newNoteID = ThreadLocalRandom.current().nextInt(5000+rs.getInt(1),5999);

                            System.out.print("Please type your observation: ");
                            String newContent = sc.nextLine();

                            // Insert a record into database with given information
                            try{
                                String insertSQL = "INSERT INTO Note(noteid,notetimestamp,appointid,content) VALUES (?,?,?,?)";
                                prestat = con.prepareStatement(insertSQL);
                                prestat.setInt(1,newNoteID);

                                SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                                String curTimestamp = sdf3.format(timestamp);
                                prestat.setString(2,curTimestamp);

                                prestat.setString(3,curAppointID);
                                prestat.setString(4,newContent);
                                prestat.executeUpdate();
                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }

                        }

                        // Option 4
                        else if (optionNum == 4){
                            int numofTest = 0;
                            int newTestID = 0;
                            // generate a new test id based on previous records of notes in database
                            try{
                                String querySQL = "SELECT COUNT(TESTID) FROM MEDICALTEST";
                                prestat = con.prepareStatement(querySQL);
                                rs = prestat.executeQuery();

                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }

                            hasRecord = rs.next();
                            if(!hasRecord){
                                newTestID = 6000;
                            }
                            newTestID = ThreadLocalRandom.current().nextInt(6000+rs.getInt(1),6999);
                            System.out.print("Please enter the type of test: ");
                            String newTestType = sc.nextLine();
                            try{
                                String insertSQL = "INSERT INTO MedicalTest(testid,prescdate,sampledate,\n" +
                                        "donedate,testresult,testtype,parcid,coupleid,numofpreg,babyid,techid) VALUES\n" +
                                        "(?,current_date,current_date ,NULL,NULL,?,?,?,?,NULL,NULL)";
                                prestat = con.prepareStatement(insertSQL);
                                prestat.setInt(1,newTestID);
                                prestat.setString(2,newTestType);
                                prestat.setString(3,mwid);
                                prestat.setString(4,curCoupleID);
                                prestat.setInt(5,curNumofPreg);
                                prestat.executeUpdate();
                            }catch (SQLException e){
                                sqlCode = e.getErrorCode(); // Get SQLCODE
                                sqlState = e.getSQLState(); // Get SQLSTATE
                                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                                System.out.println(e);
                                break mainloop;
                            }

                        }


                        else if(optionNum == 5){
                            goBack = true;
                            break;
                        }

                        else System.out.println("Invalid option! Try another option");


                    }

                }

                else{
                    if (userInput.equals("D")) {
                        goBack = false;
                    }else{
                        System.out.println("Invalid Appointment Number! Try another appointment");
                        goBack = true;
                    }
                }

            }

        }

    }
}
