<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ems.model.Attendance"%>
<%@page import="com.ems.model.Branch"%>
<%@page import="com.ems.dao.AttendanceDAO"%>
<%@page import="com.ems.dao.AttendanceDAOImpl"%>
<%@page import="com.ems.dao.BranchDAO"%>
<%@page import="com.ems.dao.BranchDAOImpl"%>
<%@page import="com.ems.model.RestaurantManager"%>
<%@page import="com.ems.dao.ManagerDAO"%>
<%@page import="com.ems.dao.ManagerDAOImpl"%>
<%@page import="com.ems.model.Employee"%>
<%@page import="com.ems.dao.EmployeeDAO"%>
<%@page import="com.ems.dao.EmployeeDAOImpl"%>
<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Salary Information</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="font-awesome.min.css">
    <link rel="stylesheet" href="line-awesome.min.css">
    <link rel="stylesheet" href="css/report-update.css">
</head>
<body>
    <%
        final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
        final ManagerDAO managerDAO = new ManagerDAOImpl();
        final EmployeeDAO employeeDAO = new EmployeeDAOImpl();
        final BranchDAO branchDAO = new BranchDAOImpl();

        // Retrieve attributes from the request
        int year = (request.getAttribute("year") != null) ? Integer.parseInt(request.getAttribute("year").toString()) : 0;
        int month = (request.getAttribute("month") != null) ? Integer.parseInt(request.getAttribute("month").toString()) : 0;
        int selectedBranchId = (request.getAttribute("branchID") != null) ? Integer.parseInt(request.getAttribute("branchID").toString()) : 0;

        RestaurantManager manager = (RestaurantManager) session.getAttribute("managerLog");
        Branch[] branches = branchDAO.getAllBranch();
        Attendance[] attendances = (selectedBranchId > 0) ? attendanceDAO.selectAllAttendance(year, month, selectedBranchId) : null;

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    %>
    <div class="main-wrapper">
        <nav class="nav-bar">
            <div class="page-title-box-1">
                <h3>REZEKY TOMYAM</h3>
            </div>
            <ul>
                <li><a href="main_officer.jsp">Home</a></li>
                <li><a href="officer_employee_list.jsp">Employee</a></li>
                <li><a href="officer_salary_main.jsp">Salary</a></li>
                <li><a href="officer_verified_report.jsp">Report</a></li>
                <li><a href="welcome.html">Log Out</a></li>
            </ul>
        </nav>
        <div class="content">
            <header class="header">
                <div class="page-title-box">
                    <h2>Report Information</h2>
                </div>
            </header>
            <main>
                <form action="attendance.view" method="post">
                    <label for="month">Month:</label>
                    <input type="month" name="month" value="${fullDate}" required>
                    <select name="branch" id="branch">
                        <% for (Branch branch : branches) { %>
                            <option value="<%= branch.getBranchID() %>" 
                                <%= (branch.getBranchID() == selectedBranchId) ? "selected" : "" %>>
                                <%= branch.getBranchName() %>
                            </option>
                        <% } %>
                    </select>
                    <input type="hidden" name="action" value="getMonthReportOfficer">
                    <button type="submit" class="submit-button">Find</button>
                </form>
                <br>
                <table class="reportTable" border="1">
                    <tr>
                        <th>Employee ID</th>
                        <th>Attendance Date</th>
                        <th>Clock In Time</th>
                        <th>Clock Out Time</th>
                        <th>Overtime Duration</th>
                        <th>Total Hours</th>
                    </tr>
                    <% if (attendances == null || attendances.length == 0) { %>
                        <tr>
                            <td colspan="6" style="text-align:center;"><em>No attendance records found</em></td>
                        </tr>
                    <% } else {
                        for (Attendance attendance : attendances) {
                            Employee employee = employeeDAO.getEmployeeByAttendance(attendance);
                    %>
                        <tr>
                            <td><%= employee.getEmployeeID() %></td>
                            <td><%= attendance.getAttendanceDate() %></td>
                            <td><%= attendance.getClockInTime() %></td>
                            <td><%= attendance.getClockOutTime() %></td>
                            <td><%= (attendance.getOvertimeDuration() != null) ? sdf.format(attendance.getOvertimeDuration()) : "No Overtime" %></td>
                            <td><%= attendance.calculateTotalHours() %></td>
                        </tr>
                    <% } } %>
                </table>
            </main>
        </div>
        <footer>
            <p>&copy; rezky tomyam employee management system</p>
        </footer>
    </div>
</body>
</html>
