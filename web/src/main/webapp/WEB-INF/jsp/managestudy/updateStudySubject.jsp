<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>

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
<jsp:useBean scope="session" id="enrollDateStr" class="java.lang.String"/>

<body class="aka_bodywidth clinexia-form-page clinexia-update-patient-page" onload=
  "if(! detectFirefoxWindows(navigator.userAgent)){document.getElementById('centralContainer').style.display='none';new Effect.Appear('centralContainer', {duration:1});};
        <c:if test='${popUpURL != ""}'>
		openDNoteWindow('<c:out value="${popUpURL}" />');</c:if>">

<div class="clinexia-update-patient-shell">
<section class="clinexia-form-hero clinexia-update-patient-hero">
    <div class="clinexia-form-hero-copy">
        <span class="clinexia-section-kicker">Patient</span>
        <h1>Update Patient</h1>
        <p>Keep the patient profile and study assignments aligned with the current workflow. Saving returns you to Patient detail.</p>
    </div>
    <div class="clinexia-form-hero-meta">
        <div class="clinexia-form-status-panel">
            <span class="clinexia-feedback-kicker">Editing</span>
            <strong><c:out value="${studySub.label}"/></strong>
            <span>Review identifiers, enrollment date and study group assignments before confirming.</span>
        </div>
    </div>
</section>

<form action="UpdateStudySubject" method="post" class="clinexia-update-patient-form">
<input type="hidden" name="action" value="confirm">
<input type="hidden" name="id" value="<c:out value="${studySub.id}"/>">
<c:choose>
<c:when test="${userBean.techAdmin || userBean.sysAdmin || userRole.manageStudy || userRole.investigator 
    || (study.parentStudyId > 0 && userRole.researchAssistant ||study.parentStudyId > 0 && userRole.researchAssistant2)}">
	 <div class="clinexia-update-card">
	<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

	<div class="tablebox_center">
	<table border="0" cellpadding="0" cellspacing="0" class="clinexia-update-fields">
	  <tr valign="top">
	  <td class="formlabel">
	  	<fmt:message key="study_subject_ID" bundle="${resword}"/>:
	  </td>
	  <td>
	  	<div class="formfieldXL_BG">
	  	<input type="text" name="label" value="<c:out value="${studySub.label}"/>" class="formfieldXL" placeholder="Enter patient ID">
	  	</div>
	  	<br>
	  	<jsp:include page="../showMessage.jsp"><jsp:param name="key" value="label"/></jsp:include>
	  </td>
	  <td class="clinexia-update-required">
	  	Required
	  </td>
	  </tr>
	  <tr valign="top">
	  <td class="formlabel"><fmt:message key="secondary_ID" bundle="${resword}"/>:</td><td><div class="formfieldXL_BG"><input type="text" name="secondaryLabel" value="<c:out value="${studySub.secondaryLabel}"/>" class="formfieldXL" placeholder="Optional secondary reference"></div>
	  	<td><jsp:include page="../showMessage.jsp"><jsp:param name="key" value="secondaryLabel"/></jsp:include></td>	  
	  </td>
	  </tr>
	  <tr valign="top">
	  <td class="formlabel"><fmt:message key="enrollment_date" bundle="${resword}"/>:</td>
	  <td>
	  <div class="formfieldXL_BG">

	  <input type="text" name="enrollmentDate" value="<c:out value="${enrollDateStr}" />" class="formfieldXL" id="enrollmentDateField" placeholder="Select enrollment date"></div>
	  <br><jsp:include page="../showMessage.jsp"><jsp:param name="key" value="enrollmentDate"/></jsp:include></td>
	  <td valign="top" class="clinexia-update-inline-actions">
	  <A HREF="#" >
	      <img src="images/bt_Calendar.gif" alt="<fmt:message key="show_calendar" bundle="${resword}"/>" title="<fmt:message key="show_calendar" bundle="${resword}"/>" border="0" id="enrollmentDateTrigger"/>
	      <script type="text/javascript">
	      Calendar.setup({inputField  : "enrollmentDateField", ifFormat    : "<fmt:message key="date_format_calender" bundle="${resformat}"/>", button      : "enrollmentDateTrigger" });
	      </script>
	  </a>
	  <c:if test="${study.studyParameterConfig.discrepancyManagement=='true'}">
	      <a href="#" onClick="openDSNoteWindow('CreateDiscrepancyNote?subjectId=${studySub.id}&id=<c:out value="${studySub.id}"/>&name=studySub&field=enrollmentDate&column=enrollment_date','spanAlert-enrollmentDate'); return false;"><img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>"></a>
	  </c:if>
	  </td>
	 </tr>
	</table>
	</div>
	</div></div></div></div></div></div></div></div>
	</div>
</c:when>
<c:otherwise>
	<div class="clinexia-update-card is-readonly">
	<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

	<div class="tablebox_center">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="clinexia-update-fields is-readonly">
	  <tr valign="top"><td class="table_header_column"><fmt:message key="label" bundle="${resword}"/>:</td><td class="table_cell">
	  <input type="text" name="label" value="<c:out value="${studySub.label}"/>" disabled="disabled" class="formfieldM">
	  </td></tr>
	  <tr valign="top"><td class="table_header_column"><fmt:message key="secondary_ID" bundle="${resword}"/>:</td><td class="table_cell">
	  <input type="text" name="secondaryLabel" value="<c:out value="${studySub.secondaryLabel}"/>" disabled="disabled" class="formfieldM">
	  </td></tr>
	  <tr valign="top"><td class="table_header_column"><fmt:message key="enrollment_date" bundle="${resword}"/>:</td><td class="table_cell">
	  <input type="text" name="enrollmentDate" value="<c:out value="${enrollDateStr}" />" disabled="disabled" class="formfieldM" id="enrollmentDateField">
	  </td></tr>
	 </table>

	 </div>
	</div></div></div></div></div></div></div></div>

	</div>
</c:otherwise>
</c:choose>

<br>
<c:if test="${(!empty groups)}">
<br>
<div class="clinexia-update-card">
<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

<div class="textbox_center">
<table border="0" cellpadding="0" class="clinexia-update-groups">

  <tr valign="top">
	<td class="formlabel"><fmt:message key="subject_group_class" bundle="${resword}"/>:
	<td class="table_cell">
	<c:set var="count" value="0"/>
	<table border="0" cellpadding="0" class="clinexia-update-group-list">
	  <c:forEach var="group" items="${groups}">
	  <tr valign="top">
	   <td><b><c:out value="${group.name}"/></b></td>
	   <td><div class="formfieldM_BG"> <select name="studyGroupId<c:out value="${count}"/>" class="formfieldM">
	    	<c:if test="${group.subjectAssignment=='Optional'}">
	    	  <option value="0">--</option>
	    	</c:if>
	    	<c:forEach var="sg" items="${group.studyGroups}">
	    	  <c:choose>
				<c:when test="${group.studyGroupId == sg.id}">
					<option value="<c:out value="${sg.id}" />" selected><c:out value="${sg.name}"/></option>
				</c:when>
				<c:otherwise>
				    <option value="<c:out value="${sg.id}"/>"><c:out value="${sg.name}"/></option>
				</c:otherwise>
			 </c:choose>
	    	</c:forEach>
	    	</select></div>
	    	<c:if test="${group.subjectAssignment=='Required'}">
	    	  <td align="left">*</td>
	    	</c:if>
	    	</td></tr>
	    	<tr valign="top">
	    	<td><fmt:message key="notes" bundle="${resword}"/>:</td>
	    	<td>
	    	<div class="formfieldXL_BG"><input type="text" class="formfieldXL" name="notes<c:out value="${count}"/>"  value="<c:out value="${group.groupNotes}"/>"></div>
	          <c:import url="../showMessage.jsp"><c:param name="key" value="notes${count}" /></c:import>
	        </td></tr>
	       <c:set var="count" value="${count+1}"/>
	  </c:forEach>
	  </table>
	</td>
  </tr>



</table>
</div>

</div></div></div></div></div></div></div></div>

</div>
</c:if>
<br>
<div class="clinexia-update-actions">
 <input type="submit" name="Submit" value="Confirm" class="button_long clinexia-update-primary">
 <input type="button" onclick="confirmCancel('ViewStudySubject?id=<c:out value="${studySub.id}"/>');"  name="cancel" value="Cancel" class="button_medium clinexia-secondary-button clinexia-update-secondary"/>
</div>
</form>
</div>
<DIV ID="testdiv1" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;"></DIV>

</body>

<jsp:include page="../include/footer.jsp"/>
