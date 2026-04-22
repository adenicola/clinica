<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<c:set var="dteFormat"><fmt:message key="date_format_string" bundle="${resformat}"/></c:set>

<c:choose>
<c:when test="${userBean.sysAdmin || userBean.techAdmin || userRole.manageStudy}">
	<jsp:include page="../include/managestudy-header.jsp"/>
</c:when>
<c:otherwise>
	<jsp:include page="../include/home-header.jsp"/>
</c:otherwise>
</c:choose>
<%-- <jsp:include page="../include/managestudy-header.jsp"/> --%>


<!-- move the alert message to the sidebar-->
<jsp:include page="../include/sideAlert.jsp"/>

<!-- then instructions-->
<tr id="sidebar_Instructions_open" style="display: none">
		<td class="sidebar_tab">

		<a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_collapse.gif" border="0" align="right" hspace="10"></a>

		<b><fmt:message key="instructions" bundle="${resword}"/></b>

		<div class="sidebar_tab_content">
		</div>

		</td>

	</tr>
	<tr id="sidebar_Instructions_closed" style="display: all">
		<td class="sidebar_tab">

		<a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_expand.gif" border="0" align="right" hspace="10"></a>

		<b><fmt:message key="instructions" bundle="${resword}"/></b>

		</td>
  </tr>
<jsp:include page="../include/sideInfo.jsp"/>

<jsp:useBean scope="session" id="studySub" class="org.akaza.openclinica.bean.managestudy.StudySubjectBean"/>

<div class="clinexia-update-patient-shell clinexia-update-patient-confirm">
<section class="clinexia-form-hero clinexia-update-patient-hero">
    <div class="clinexia-form-hero-copy">
        <span class="clinexia-section-kicker">Patient</span>
        <h1>Review Patient Changes</h1>
        <p>Confirm the updated patient profile before saving. After save, Clinexia returns you to Patient detail with a success message.</p>
    </div>
    <div class="clinexia-form-hero-meta">
        <div class="clinexia-form-status-panel">
            <span class="clinexia-feedback-kicker">Ready to save</span>
            <strong><c:out value="${studySub.label}"/></strong>
            <span>Review the details below and confirm when you are ready.</span>
        </div>
    </div>
</section>

<form action="UpdateStudySubject" method="post" class="clinexia-update-patient-form">
<input type="hidden" name="action" value="submit">
<input type="hidden" name="id" value="<c:out value="${studySub.id}"/>">
 <div class="clinexia-update-card">
<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

<div class="tablebox_center">
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="clinexia-update-summary-table">
  <tr valign="bottom"><td class="table_header_column">Patient ID:</td><td class="table_cell"><c:out value="${studySub.label}"/></td></tr>
  <tr valign="bottom"><td class="table_header_column"><fmt:message key="secondary_ID" bundle="${resword}"/>:</td><td class="table_cell"><c:out value="${studySub.secondaryLabel}"/>&nbsp;
  </td></tr>
  <tr valign="bottom"><td class="table_header_column"><fmt:message key="enrollment_date" bundle="${resword}"/>:</td>
  <td class="table_cell"><fmt:formatDate value="${studySub.enrollmentDate}" pattern="${dteFormat}"/></td></tr>
  <tr valign="top"><td class="table_header_column"><fmt:message key="created_by" bundle="${resword}"/>:</td><td class="table_cell"><c:out value="${studySub.owner.name}"/></td></tr>
  <tr valign="top"><td class="table_header_column"><fmt:message key="date_created" bundle="${resword}"/>:</td><td class="table_cell"><fmt:formatDate value="${studySub.createdDate}" pattern="${dteFormat}"/>
  </td></tr>
  <tr valign="top"><td class="table_header_column"><fmt:message key="last_updated_by" bundle="${resword}"/>:</td><td class="table_cell"><c:out value="${studySub.updater.name}"/>&nbsp;
  </td></tr>
  <tr valign="top"><td class="table_header_column"><fmt:message key="date_updated" bundle="${resword}"/>:</td><td class="table_cell"><fmt:formatDate value="${studySub.updatedDate}" pattern="${dteFormat}"/>&nbsp;
  </td></tr>

</table>
</div>
</div></div></div></div></div></div></div></div>

</div>
<c:if test="${(!empty groups)}">
<br>
<div class="clinexia-update-card">
<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

<div class="textbox_center">
<table border="0" cellpadding="0" class="clinexia-update-summary-table">

  <tr valign="top">
	<td class="table_header_column"><fmt:message key="subject_group_class" bundle="${resword}"/>:
	<td class="table_cell">

	<table border="0" cellpadding="0">
	  <c:forEach var="group" items="${groups}">
	  <tr valign="top">
	   <td><b><c:out value="${group.name}"/></b></td>
	   <td><c:out value="${group.studyGroupName}"/></td></tr>
	    <tr valign="top">
	      <td><fmt:message key="notes" bundle="${resword}"/>:</td>
	      <td><c:out value="${group.groupNotes}"/></td>
	    </tr>
	  </c:forEach>
	  </table>
	</td>
  </tr>



</table>
</div>

</div></div></div></div></div></div></div></div>

</div>
</c:if>
<div class="clinexia-update-actions">
 <input type="submit" name="Submit" value="Confirm" class="button_long clinexia-update-primary">
 <input type="button" onclick="confirmCancel('ViewStudySubject?id=<c:out value="${studySub.id}"/>');" name="cancel" value="Cancel" class="button_medium clinexia-secondary-button clinexia-update-secondary">
</div>
</form>
</div>
<jsp:include page="../include/footer.jsp"/>
