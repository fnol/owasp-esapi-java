<%@page import="org.owasp.esapi.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<html>
<head>
<title>ESAPI Test Application</title>
</head>

<body>
<%@include file="menu.jsp" %>
<h2>User List</h2>
<ul>

<%
	String message = (String)request.getAttribute("message");
	if ( message != null )  {
%>
<h3><%=message %></h3>
<%
	}
%>

<%
	AccessReferenceMap usermap = (AccessReferenceMap)session.getAttribute( "usermap" );
	
	if ( usermap != null ) {
		Iterator i = usermap.iterator();
		while ( i.hasNext() ) {
			String userName = (String)i.next();
			User u = ESAPI.authenticator().getUser( userName );
			if ( u == null ) {
				logger.logCritical( Logger.SECURITY, "Serious error getting user from usermap" );
			}
			else {
				String funcEnable = "controller?function=enable";
				String funcDisable = "controller?function=disable";
				String funcLock = "controller?function=lock";
				String funcUnlock = "controller?function=unlock";
				String funcDelete = "controller?function=delete";
				String funcPassword = "controller?function=password";
				String ref = "&user=" + usermap.getIndirectReference(userName);
%>
	<li>

    <%=ESAPI.encoder().encodeForHTML(u.getAccountName())%>
<%
				if ( u.isEnabled() ) {
%>
   	<a href="<%=funcDisable%><%=ref%>">disable</a>
<%
				} else {
%>
	<a href="<%=funcEnable%><%=ref%>">enable</a>
<%
				}

				if ( u.isLocked() ) {
%>
	<a href="<%=funcUnlock%><%=ref%>">unlock</a>
<%
				} else {
%>
   	<a href="<%=funcLock%><%=ref%>">lock</a>
<%
				}
%>

    <a href="<%=funcDelete%><%=ref%>">delete</a>
	<a href="<%=funcPassword%><%=ref%>">reset password</a>
			    (
<%
				Iterator j = u.getRoles().iterator();
				while ( j.hasNext() ) {
					String role = (String)j.next();
%>						
						<%=ESAPI.encoder().encodeForHTML(role) %>
<%
				}
%>
				)
	</li>
<%
			}  // end if u != null
		}  // end while
	}
%>
</ul>

<%
	String newPassword = ESAPI.encoder().encodeForHTML((String)request.getAttribute("newPassword" ));
	if ( newPassword != null && !newPassword.isEmpty() ) {
%>
	<table border=1>
		<tr><td>New Password Generated</td></tr>
		<tr><td><%=newPassword%></td></tr>
	</table>
<%
	}
%>
<HR>
<h2>Create a user</h2>
		<FORM method="post" action="controller?function=create">
		<table>
			<tr><td>username: <INPUT name="username"></td></tr>
			<tr><td>roles: <INPUT name="roles"></td></tr>
			<tr><td>duration: <INPUT name="days"> days</td></tr>
		</table>
		<BUTTON type="submit">create</BUTTON>
		</FORM>

</body>
</html>
