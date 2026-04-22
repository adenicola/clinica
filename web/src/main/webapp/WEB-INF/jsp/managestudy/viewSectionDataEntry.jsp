<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="com.akazaresearch.tags" prefix="aka_frm" %>

<jsp:useBean scope='session' id='studySubjectId' class='java.lang.String'/>

<jsp:useBean scope='session' id='userBean' class='org.akaza.openclinica.bean.login.UserAccountBean'/>
<jsp:useBean scope='session' id='study' class='org.akaza.openclinica.bean.managestudy.StudyBean'/>
<jsp:useBean scope='session' id='userRole' class='org.akaza.openclinica.bean.login.StudyUserRoleBean'/>
<jsp:useBean scope='request' id='isAdminServlet' class='java.lang.String'/>
<jsp:useBean scope='request' id='crfListPage' class='java.lang.String'/>
<jsp:useBean scope='request' id='crfId' class='java.lang.String'/>
<jsp:useBean scope='request' id='eventId' class='java.lang.String'/>
<jsp:useBean scope='request' id='exitTo' class='java.lang.String'/>
<jsp:useBean scope="request" id="fromViewNotes" class="java.lang.String"/>
<jsp:useBean scope="session" id="viewNotesURL" class="java.lang.String"/>

<jsp:useBean scope="request" id="section" class="org.akaza.openclinica.bean.submit.DisplaySectionBean"/>

<jsp:useBean scope="request" id="annotations" class="java.lang.String"/>
<jsp:useBean scope='request' id='pageMessages' class='java.util.ArrayList'/>
<jsp:useBean scope='request' id='formMessages' class='java.util.HashMap'/>

<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<c:set var="formDisplayName" value="${toc.crf.name}" />
<c:if test="${!empty toc.crfVersion.name}">
    <c:set var="formDisplayName" value="${formDisplayName} ${toc.crfVersion.name}" />
</c:if>
<c:set var="currentSectionName" value="${section.section.title}" />
<c:if test="${empty currentSectionName}">
    <c:set var="currentSectionName" value="${section.section.label}" />
</c:if>
<c:set var="stage" value="${param.stage}"/>
<c:set var="formStatusClass" value="clinexia-status-badge-active" />
<c:set var="formStatusLabel" value="In progress" />
<c:set var="feedbackToneClass" value="is-info" />
<c:set var="feedbackHeadline" value="Continue entering data" />
<c:set var="feedbackCopy" value="Save progress at any time. The visit can be completed from the final section." />
<c:choose>
    <c:when test="${eventCRF.stage.initialDE_Complete || eventCRF.stage.doubleDE_Complete}">
        <c:set var="formStatusClass" value="clinexia-status-badge-completed" />
        <c:set var="formStatusLabel" value="Completed" />
        <c:set var="feedbackToneClass" value="is-success" />
        <c:set var="feedbackHeadline" value="Completed" />
        <c:set var="feedbackCopy" value="This form was already completed for the current visit." />
    </c:when>
    <c:when test="${eventCRF.stage.locked}">
        <c:set var="formStatusClass" value="clinexia-status-badge-completed" />
        <c:set var="formStatusLabel" value="Locked" />
        <c:set var="feedbackToneClass" value="is-success" />
        <c:set var="feedbackHeadline" value="Completed" />
        <c:set var="feedbackCopy" value="This form is locked and no further changes are expected." />
    </c:when>
    <c:when test="${eventCRF.stage.invalid}">
        <c:set var="formStatusClass" value="clinexia-status-badge-screened" />
        <c:set var="formStatusLabel" value="Needs review" />
        <c:set var="feedbackToneClass" value="is-warning" />
        <c:set var="feedbackHeadline" value="Needs review" />
        <c:set var="feedbackCopy" value="Review highlighted responses before continuing." />
    </c:when>
    <c:when test="${eventCRF.stage.admin_Editing}">
        <c:set var="formStatusClass" value="clinexia-status-badge-screened" />
        <c:set var="formStatusLabel" value="Admin editing" />
        <c:set var="feedbackToneClass" value="is-warning" />
        <c:set var="feedbackHeadline" value="Admin editing" />
        <c:set var="feedbackCopy" value="This form is currently being updated in administrative editing mode." />
    </c:when>
</c:choose>
<c:if test="${!empty pageMessages}">
    <c:set var="feedbackToneClass" value="is-success" />
    <c:set var="feedbackHeadline" value="Saved" />
    <c:set var="feedbackCopy" value="Changes were saved successfully. You can continue editing or move to the next step." />
</c:if>
<c:if test="${!empty formMessages}">
    <c:set var="feedbackToneClass" value="is-error" />
    <c:set var="feedbackHeadline" value="Error" />
    <c:set var="feedbackCopy" value="Some fields still need attention. Review the highlighted items before saving again." />
</c:if>
<c:set var="nextActionToneClass" value="is-info" />
<c:if test="${section.lastSection}">
    <c:set var="nextActionToneClass" value="is-warning" />
</c:if>
<c:if test="${!empty formMessages}">
    <c:set var="nextActionToneClass" value="is-error" />
</c:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<c:set var="contextPath" value="${fn:replace(pageContext.request.requestURL, fn:substringAfter(pageContext.request.requestURL, pageContext.request.contextPath), '')}" />

    <title>Clinexia Form</title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />

    <link rel="icon" type="image/png" href="<c:url value='/images/clinexia-favicon.png'/>">
    <link rel="stylesheet" href="includes/styles.css" type="text/css" media="screen">
    <link rel="stylesheet" href="includes/modern-theme.css" type="text/css" media="screen">
    <link rel="stylesheet" href="includes/print.css" type="text/css" media="print">
    <script type="text/JavaScript" language="JavaScript" src="includes/global_functions_javascript.js"></script>
    <script type="text/JavaScript" language="JavaScript" src="includes/Tabs.js"></script>
    <!--<script type="text/JavaScript" language="JavaScript" src="includes/CalendarPopup.js"></script> -->
    <script type="text/javascript" language="JavaScript" src="includes/repetition-model/repetition-model.js"></script>
    <script type="text/JavaScript" language="JavaScript" src="includes/prototype.js"></script>
    <script type="text/JavaScript" language="JavaScript" src="includes/scriptaculous.js?load=effects"></script>
    <script type="text/JavaScript" language="JavaScript" src="includes/effects.js"></script>
    <!-- Added for the new Calendar -->

    <link rel="stylesheet" type="text/css" media="all" href="includes/new_cal/skins/aqua/theme.css" title="Aqua" />
    <script type="text/javascript" src="includes/new_cal/calendar.js"></script>
    <script type="text/javascript" src="includes/new_cal/lang/calendar-en.js"></script>
    <script type="text/javascript" src="includes/new_cal/lang/<fmt:message key="jscalendar_language_file" bundle="${resformat}"/>"></script>
    <script type="text/javascript" src="includes/new_cal/calendar-setup.js"></script>
    <!-- End -->

</head>
<body class="aka_bodywidth clinexia-form-page" onload="
        <c:if test='${popUpURL != ""}'>
        openDNoteWindow('<c:out value="${popUpURL}" />');</c:if>document.getElementById('CRF_infobox_closed').style.display='block';document.getElementById('CRF_infobox_open').style.display='none';clinexiaInitFormExperience();">

<%-- BWP: TabsForwardByNum(<c:out value="${tabId}"/>)alert(self.screen.availWidth);
margin-top:20px;margin-top:10px;document.getElementById('centralContainer').style.display='none';new Effect.Appear('centralContainer', {duration:1});updateTabs(<c:out value="${tabId}"/>);--%>

<div id="centralContainer" class="clinexia-form-page-shell">
<div class="clinexia-form-hero">
    <div class="clinexia-form-hero-copy">
        <span class="clinexia-form-eyebrow">Clinexia Form</span>
        <h1 class="clinexia-form-title"><c:out value="${formDisplayName}" /></h1>
        <p class="clinexia-form-note">Capture visit data with the same validation and permissions as the legacy workflow, in a cleaner Clinexia experience.</p>
        <div class="clinexia-form-hero-meta">
            <span class="clinexia-status-badge ${formStatusClass}"><c:out value="${formStatusLabel}" /></span>
            <span class="clinexia-readonly-inline">
                <span class="clinexia-readonly-label">Patient ID</span>
                <span class="clinexia-readonly-value"><c:out value="${studySubject.label}" /></span>
            </span>
            <span class="clinexia-readonly-inline">
                <span class="clinexia-readonly-label">Current section</span>
                <span class="clinexia-readonly-value clinexia-section-name"><c:out value="${currentSectionName}" escapeXml="false" /></span>
            </span>
        </div>
    </div>
    <div class="clinexia-form-status-panel">
        <span class="clinexia-readonly-label">Form status</span>
        <strong><c:out value="${formStatusLabel}" /></strong>
        <span>Save progress anytime and complete the visit from the last section.</span>
    </div>
</div>

<table class="clinexia-form-legacy-title" width="75%"><tr><td>
<h1><span class="title_manage"> <b> <c:out value="${toc.crf.name}" /> <c:out value="${toc.crfVersion.name}" />
         <c:choose>
            <c:when test="${eventCRF.stage.initialDE}">
                <img src="images/icon_InitialDE.gif" alt="<fmt:message key="initial_data_entry" bundle="${resword}"/>"
                     title="<fmt:message key="initial_data_entry" bundle="${resword}"/>">
            </c:when>
            <c:when
              test="${eventCRF.stage.initialDE_Complete}">
                <img src="images/icon_InitialDEcomplete.gif"
                     alt="<fmt:message key="initial_data_entry_complete" bundle="${resword}"/>"
                     title="<fmt:message key="initial_data_entry_complete" bundle="${resword}"/>">
            </c:when>
            <c:when test="${eventCRF.stage.doubleDE}">
                <img src="images/icon_DDE.gif" alt="<fmt:message key="double_data_entry" bundle="${resword}"/>"
                     title="<fmt:message key="double_data_entry" bundle="${resword}"/>">
            </c:when>
            <c:when test="${eventCRF.stage.doubleDE_Complete}">
                <img src="images/icon_DEcomplete.gif" alt="<fmt:message key="data_entry_complete" bundle="${resword}"/>"
                     title="<fmt:message key="data_entry_complete" bundle="${resword}"/>">
            </c:when>
            <c:when test="${eventCRF.stage.admin_Editing}">
                <img src="images/icon_AdminEdit.gif"
                     alt="<fmt:message key="administrative_editing" bundle="${resword}"/>" title="<fmt:message key="administrative_editing" bundle="${resword}"/>">
            </c:when>
            <c:when test="${eventCRF.stage.locked}">
                <img src="images/icon_Locked.gif" alt="<fmt:message key="locked" bundle="${resword}"/>" title="<fmt:message key="locked" bundle="${resword}"/>">
            </c:when>
            <c:when test="${eventCRF.stage.invalid}">
                <img src="images/icon_Invalid.gif" alt="<fmt:message key="invalid" bundle="${resword}"/>" title="<fmt:message key="invalid" bundle="${resword}"/>">
            </c:when>
            <c:otherwise>

            </c:otherwise>
        </c:choose></b>  &nbsp;&nbsp;</span> </h1> </td><td>
		<h1><span class="title_manage"> <c:out value="${studySubject.label}" />&nbsp;&nbsp; </span></h1></td></tr></table>



<%--<c:if test="${tabId == null || tabId == 0 || fn:length(tabId) < 1}">
    <c:set var="tabId" value="1" />
</c:if>
<c:if test="${! (param.tab == 0 || fn:length(param.tab) < 1)}">
    <c:set var="tabId" value="${param.tab}" />
</c:if>--%>

<form id="mainForm" name="crfForm" method="POST" action="ViewSectionDataEntry">
<input type ="hidden" name="action" value="saveNotes"/>
<input type="hidden" name="ecId" value="<c:out value="${section.eventCRF.id}"/>" />
<input type="hidden" name="sectionId" value="<c:out value="${section.section.id}"/>" />
<input type="hidden" name="tab" value="<c:out value="${tabId}"/>" />
<input type="hidden" name="studySubjectId" value="<c:out value="${studySubjectId}"/>" />
<input type="hidden" name="eventDefinitionCRFId"  value="<c:out value="${eventDefinitionCRFId}"/>" />
<script type="text/javascript" language="JavaScript">
    // <![CDATA[
    function getSib(theSibling) {
        var sib;
        do {
            sib = theSibling.previousSibling;
            if (sib.nodeType != 1) {
                theSibling = sib;
            }
        } while (! (sib.nodeType == 1))

        return sib;
    }



    // ]]>
</script>

<c:import url="../submit/interviewer.jsp"/>
<%-- <c:param var="fromPage" value="vsde"/>
</c:import> --%>
<!--<br><br>-->

<c:set var="eventId" value="${eventId}"/>
<c:set var="studySubjectId" value="${studySubjectId}"/>
<c:set var="crfListPage" value="${crfListPage}"/>
<c:set var="crfId" value="${crfId}"/>
<c:set var="sectionNum" value="0"/>
<c:forEach var="section" items="${toc.sections}">
    <c:set var="sectionNum" value="${sectionNum+1}"/>
</c:forEach>
<c:set var="sectionProgressPercent" value="0"/>
<c:if test="${sectionNum > 0}">
    <fmt:parseNumber var="sectionProgressPercent" integerOnly="true" value="${(tabId * 100) / sectionNum}" />
</c:if>

<div class="clinexia-form-shell">
<div class="clinexia-form-card clinexia-form-overview-card">
    <div class="clinexia-form-overview">
        <div>
            <span class="clinexia-form-eyebrow">Visit form</span>
            <h2><c:out value="${currentSectionName}" escapeXml="false"/></h2>
            <p>Answer the required questions for this section, then save or continue when you're ready.</p>
        </div>
        <div class="clinexia-form-meta">
            <span id="clinexiaFormSaveState" class="clinexia-feedback-badge is-saved">All changes saved</span>
        </div>
    </div>
    <div class="clinexia-form-progress-card">
        <div class="clinexia-form-progress-copy">
            <span class="clinexia-feedback-kicker">Section progress</span>
            <strong>Section <c:out value="${tabId}" /> of <c:out value="${sectionNum}" /></strong>
            <span>
                <c:choose>
                    <c:when test="${section.lastSection}">You're on the final section of this form.</c:when>
                    <c:otherwise>Complete this section to move smoothly through the visit.</c:otherwise>
                </c:choose>
            </span>
        </div>
        <div class="clinexia-progress-track clinexia-form-progress-track" aria-hidden="true">
            <span class="clinexia-progress-bar clinexia-form-progress-bar" style="width: <c:out value='${sectionProgressPercent}'/>%;"></span>
        </div>
    </div>
    <div class="clinexia-feedback-strip clinexia-feedback-strip-form">
        <article class="clinexia-feedback-tile ${feedbackToneClass}">
            <span class="clinexia-feedback-kicker">Form feedback</span>
            <strong><c:out value="${feedbackHeadline}"/></strong>
            <span><c:out value="${feedbackCopy}"/></span>
        </article>
        <article class="clinexia-feedback-tile is-status">
            <span class="clinexia-feedback-kicker">Form status</span>
            <strong><c:out value="${formStatusLabel}"/></strong>
            <span>The current data-entry stage is visible at all times while you work.</span>
        </article>
        <article class="clinexia-feedback-tile ${nextActionToneClass}">
            <span class="clinexia-feedback-kicker">Next action</span>
            <strong>
                <c:choose>
                    <c:when test="${!empty formMessages}">Review highlighted fields</c:when>
                    <c:when test="${section.lastSection}">Save or complete this visit</c:when>
                    <c:otherwise>Save and continue to the next section</c:otherwise>
                </c:choose>
            </strong>
            <span>
                <c:choose>
                    <c:when test="${!empty formMessages}">Field-level errors stay visible directly next to the affected responses.</c:when>
                    <c:when test="${section.lastSection}">The final section enables the complete visit action without changing the legacy workflow.</c:when>
                    <c:otherwise>Use the Save action to keep progress and move through the visit step by step.</c:otherwise>
                </c:choose>
            </span>
        </article>
    </div>
    <c:if test="${!empty pageMessages}">
        <div class="clinexia-form-page-messages">
            <jsp:include page="../include/showPageMessages.jsp" />
        </div>
    </c:if>
</div>

<div class="clinexia-form-card clinexia-form-toolbar-card">
    <div class="clinexia-form-actions">
        <c:choose>
        <c:when test="${fn:length(fromViewNotes)>0 && !empty viewNotesURL}">
            <input type="button" onclick="window.location = '<c:out value="${viewNotesURL}"/>'" value="Cancel" class="button_medium clinexia-secondary-button"/>
        </c:when>
        <c:otherwise>
        <c:choose>
            <c:when test="${!empty window_location}">
                <input type="button" onclick="window.location = '<c:out value="${window_location}"/>'" value="Cancel" class="button_medium clinexia-secondary-button"/>
            </c:when>
            <c:when test="${!empty exitTo}">
                <c:if test="${exitTo != 'none'}">
                    <input type="button" onclick="window.location = '<c:out value="${exitTo}"/>'" value="Cancel" class="button_medium clinexia-secondary-button"/>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${crfListPage == 'yes'}">
                        <input type="button" onclick="window.location = 'ListCRF?&module=';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
                    </c:when>
                    <c:when test="${studySubjectId > 0}">
                        <input type="button" onclick="window.location = 'ViewStudySubject?id=<c:out value="${studySubjectId}"/>';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
                    </c:when>
                    <c:when test="${eventId > 0}">
                        <input type="button" onclick="window.location = 'EnterDataForStudyEvent?eventId=<c:out value="${eventId}"/>';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
                    </c:when>
                    <c:otherwise>
                        <input type="button" onclick="window.location = 'ViewCRF?crfId=<c:out value="${crfId}"/>';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
        </c:otherwise>
        </c:choose>
        <button type="submit" name="submittedResume" value="Save" class="button_medium clinexia-primary-submit" onclick="clinexiaClearCompleteIntent();">Save</button>
        <c:if test="${stage != 'adminEdit' && section.lastSection}">
            <button type="submit" name="submittedResume" value="Save" class="button_medium clinexia-complete-submit" onclick="return clinexiaPrepareComplete();">Complete Visit</button>
        </c:if>
    </div>
    <div class="clinexia-form-toolbar-meta">
        <span class="clinexia-form-hint">Save to keep your progress, or cancel to return without breaking the workflow.</span>
    </div>
</div>

<%-- removed, tbh 102007 --%>
<%--
 <br />
<div class="homebox_bullets">
  <a href="ViewCRFVersion?id=<c:out value="${section.crfVersion.id}"/>"><fmt:message key="view_CRF_version_metadata" bundle="${resworkflow}"/></a></div>
<br />
  <div class="homebox_bullets"><a href="ViewCRF?crfId=<c:out value="${section.crf.id}"/>">View CRF Details</a></div>
<br />
			<div class="homebox_bullets"><a href="ListCRF">Go Back to CRF List</a></div>
<br />
--%>
<!-- section tabs here -->
<div class="clinexia-form-card clinexia-form-tabs-card">
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<%-- if only one section show no arrows & section jump --%>
<c:if test="${fn:length(toc.sections) gt 1}">

<td align="right" valign="middle" style="padding-left: 12px; display: none" id="TabsBack">
    <a href="javascript:TabsBack()"><img src="images/arrow_back.gif" border="0" style="margin-top:10px"></a></td>
<td align="right" style="padding-left: 12px" id="TabsBackDis">
    <img src="images/arrow_back_dis.gif" border="0"/></td>
</c:if>

<script type="text/JavaScript" language="JavaScript">

    // Total number of tabs (one for each CRF)
    var TabsNumber = <c:out value="${sectionNum}"/>;


    // Number of tabs to display at a time  o
    var TabsShown = 3;


    // Labels to display on each tab (name of CRF)
    var TabLabel = new Array(TabsNumber)
    var TabFullName = new Array(TabsNumber)
    var TabSectionId = new Array(TabsNumber)
    <c:set var="count" value="0"/>
    <c:forEach var="section" items="${toc.sections}">
    <c:set var="completedItems" value="${section.numItemsCompleted}"/>
    <c:if test="${section.numItemsCompleted == 0 && toc.eventDefinitionCRF.doubleEntry}">
    <c:set var="completedItems" value="${section.numItemsNeedingValidation}"/>
    </c:if>
    TabFullName[<c:out value="${count}"/>] = "<c:out value="${section.label}"/> (<c:out value="${section.numItemsCompleted}"/>/<c:out value="${section.numItems}" />)";

    TabSectionId[<c:out value="${count}"/>] = <c:out value="${section.id}"/>;

    TabLabel[<c:out value="${count}"/>] = "<c:out value="${section.label}"/>";
    if (TabLabel[<c:out value="${count}"/>].length > 8) {
        var shortName = TabLabel[<c:out value="${count}"/>].substring(0, 7);
        TabLabel[<c:out value="${count}"/>] = shortName + '...' + "<span id='secNumItemsCom<c:out value="${count}"/>' style='font-weight: normal;'>(<c:out value="${completedItems}"/>/<c:out value="${section.numItems}" />)</span>";
    } else {
        TabLabel[<c:out value="${count}"/>] = "<c:out value="${section.label}"/> " + "<span id='secNumItemsCom<c:out value="${count}"/>' style='font-weight: normal;'>(<c:out value="${completedItems}"/>/<c:out value="${section.numItems}" />)</span>";
    }

    <c:set var="count" value="${count+1}"/>
    </c:forEach>
    DisplaySectionTabs();

    selectTabs(${tabId},${sectionNum},'crfHeaderTabs');

    function DisplaySectionTabs() {
        TabID = 1;

        while (TabID <= TabsNumber)
        {
            sectionId = TabSectionId[TabID - 1];
        <c:choose>
        <c:when test="${studySubject != null && studySubject.id>0}">
            url = "ViewSectionDataEntry?ecId=" + <c:out value="${EventCRFBean.id}"/> + "&crfVersionId=${section.crfVersion.id}&sectionId=" + sectionId + "&tabId=" + TabID + "&studySubjectId=${studySubjectId}"+"&eventDefinitionCRFId=${eventDefinitionCRFId}&exitTo=${exitTo}";

        </c:when>
        <c:otherwise>
            url = "ViewSectionDataEntry?crfVersionId=" + <c:out value="${section.crfVersion.id}"/> + "&sectionId=" + sectionId + "&ecId=" + <c:out value="${EventCRFBean.id}"/> + "&tabId=" + TabID+"&eventDefinitionCRFId=${eventDefinitionCRFId}&exitTo=${exitTo}";

        </c:otherwise>
        </c:choose>
            currTabID = <c:out value="${tabId}"/>;
            if (TabID <= TabsShown)
            {
                document.write('<td class="crfHeaderTabs" valign="bottom" id="Tab' + TabID + '">');
            }
            else
            {
                document.write('<td class="crfHeaderTabs" valign="bottom" id="Tab' + TabID + '">');
            }
            if (TabID != currTabID) {
                document.write('<div id="Tab' + TabID + 'NotSelected" style="display:all"><div class="tab_BG"><div class="tab_L"><div class="tab_R">');
                document.write('<a class="tabtext" title="' + TabFullName[(TabID - 1)] + '" href=' + url + '>' + TabLabel[(TabID - 1)] + '</a></div></div></div></div>');
                document.write('<div id="Tab' + TabID + 'Selected" style="display:none"><div class="tab_BG_h"><div class="tab_L_h"><div class="tab_R_h"><span class="tabtext">' + TabLabel[(TabID - 1)] + '</span></div></div></div></div>');
                document.write('</td>');
            }
            else {
                document.write('<div id="Tab' + TabID + 'NotSelected" style="display:all"><div class="tab_BG_h"><div class="tab_L_h"><div class="tab_R_h">');
                document.write('<span class="tabtext">' + TabLabel[(TabID - 1)] + '</span></div></div></div></div>');
                document.write('<div id="Tab' + TabID + 'Selected" style="display:none"><div class="tab_BG_h"><div class="tab_L_h"><div class="tab_R_h"><span class="tabtext">' + TabLabel[(TabID - 1)] + '</span></div></div></div></div>');
                document.write('</td>');
            }

            TabID++

        }
    }
    /*
function checkDataStatus() {

 objImage=document.getElementById('status_top');
 if (objImage != null && objImage.src.indexOf('images/icon_UnsavedData.gif')>0) {
   return confirm('<fmt:message key="you_have_unsaved_data" bundle="${resword}"/>');
    }

    return true;
  }*/
    function gotoLink() {
        var OptionIndex = document.crfForm.sectionSelect.selectedIndex;
        window.location = document.crfForm.sectionSelect.options[OptionIndex].value;
    }

 function $(x){return document.getElementById(x);}
    //-->
</script>

<%-- if only one section show no arrows & section jump --%>
<c:if test="${fn:length(toc.sections) gt 1}">

<td align="right" id="TabsNextDis" style="display: none"><img src="images/arrow_next_dis.gif" border="0"/></td>
<td align="right" id="TabsNext"><a href="javascript:TabsForward()"><img src="images/arrow_next.gif" border="0" style=
  "margin-top:10px;margin-right:6px"/></a></td>
<td>&nbsp;
    <div class="formfieldM_BG_noMargin">
        <select class="formfieldM" name="sectionSelect" size="1" onchange="gotoLink();">
            <c:set var="tabCount" value="1"/>
            <option selected>-- <fmt:message key="select_to_jump" bundle="${resword}"/> --</option>
            <c:forEach var="sec" items="${toc.sections}">
                <c:choose>
                    <c:when test="${studySubject != null && studySubject.id>0}">
                        <c:set var="tabUrl"
                               value="ViewSectionDataEntry?ecId=${EventCRFBean.id}&crfVersionId=${section.crfVersion.id}&sectionId=${sec.id}&tabId=${tabCount}&studySubjectId=${studySubjectId}&eventDefinitionCRFId=${eventDefinitionCRFId}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="tabUrl"
                               value="ViewSectionDataEntry?crfVersionId=${section.crfVersion.id}&sectionId=${sec.id}&ecId=${EventCRFBean.id}&tabId=${tabCount}&eventDefinitionCRFId=${eventDefinitionCRFId}"/>
                    </c:otherwise>
                </c:choose>
                <option value="<c:out value="${tabUrl}"/>"><c:out value="${sec.name}"/></option>
                <c:set var="tabCount" value="${tabCount+1}"/>
            </c:forEach>
        </select>
    </div>
</td>
</c:if>
</tr>
</table>
</div>

<script type="text/javascript" language="JavaScript">
    <!--
    function checkSectionStatus() {

        objImage = document.getElementById('status_top');
    //alert(objImage.src);
        if (objImage != null && objImage.src.indexOf('images/icon_UnsavedData.gif') > 0) {
            return confirm('<fmt:message key="you_have_unsaved_data2" bundle="${resword}"/>');
        }

        return true;
    }


    function checkEntryStatus(strImageName) {
        objImage = MM_findObj(strImageName);
    //alert(objImage.src);
        if (objImage != null && objImage.src.indexOf('images/icon_UnsavedData.gif') > 0) {
            return confirm('<fmt:message key="you_have_unsaved_data_exit" bundle="${resword}"/>');
        }
        return true;
    }
    //-->
</script>

<div class="clinexia-form-card clinexia-form-stage-card">
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<td>
<div style="width:100%">
<!-- These DIVs define shaded box borders -->
<div class="box_T">
<div class="box_L">
<div class="box_R">
<div class="box_B">
<div class="box_TL">
<div class="box_TR">
<div class="box_BL">
<div class="box_BR">
<div class="tablebox_center">
<c:set var="currPage" value=""/>
<c:set var="curCategory" value=""/>

<!-- include return to top table-->
<!-- Table Contents -->

<table border="0" cellpadding="0" cellspacing="0" class="clinexia-form-content-table">
<c:set var="displayItemNum" value="${0}" />
<c:set var="itemNum" value="${0}" />
<c:set var="numOfTr" value="0"/>
<c:set var="numOfDate" value="1"/>
<c:if test='${section.section.title != ""}'>
    <tr class="aka_stripes">
        <td class="aka_header_border"><b><fmt:message key="title" bundle="${resword}"/>:&nbsp;<c:out value="${section.section.title}" escapeXml="false"/></b> </td>
    </tr>
</c:if>
<c:if test='${section.section.subtitle != ""}'>
    <tr class="aka_stripes">
        <td class="aka_header_border"><fmt:message key="subtitle" bundle="${resword}"/>:&nbsp;<c:out value="${section.section.subtitle}" escapeXml="false"/> </td>
    </tr>
</c:if>
<c:if test='${section.section.instructions != ""}'>
    <tr class="aka_stripes">
        <td class="aka_header_border"><fmt:message key="instructions" bundle="${resword}"/>:&nbsp;<c:out value="${section.section.instructions}" escapeXml="false"/> </td>
    </tr>
</c:if>
<c:set var="repeatCount" value="1"/>
<c:forEach var="displayItem" items="${section.displayItemGroups}" varStatus="itemStatus">

<c:if test="${displayItemNum ==0}">
    <!-- always show the button and page above the first item-->
    <!-- to handle the case of no pageNumLabel for all the items-->
    <%--  BWP: corrected "column span="2" "--%>
    <c:if test="${displayItem.pageNumberLabel != ''}">
    <tr class="aka_stripes">
            <%--  <td class="aka_header_border" colspan="2">width="100%"--%>
        <td class="aka_header_border" colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" style="margin-bottom: 6px;">
                <tr>

                    <td valign="bottom" nowrap="nowrap" style="padding-right: 50px">

                        <a name="top"><fmt:message key="page" bundle="${resword}"/>: <c:out value="${displayItem.pageNumberLabel}" escapeXml="false"/></a>
                    </td>

                </tr>
            </table>
        </td>
    </tr>
    </c:if>
</c:if>

<c:if test="${currPage != displayItem.pageNumberLabel && displayItemNum >0}">
    <!-- show page number and buttons -->
    <%--  BWP: corrected "column span="2" "  width="100%"--%>
    <tr class="aka_stripes">
        <td class="aka_header_border" colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" style="margin-bottom: 6px;">
                <tr>

                    <td valign="bottom" nowrap="nowrap" style="padding-right: 50px">
                        <fmt:message key="page" bundle="${resword}"/>: <c:out value="${displayItem.pageNumberLabel}" escapeXml="false"/>
                    </td>
                    <td align="right" valign="bottom">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <c:choose>
                                    <c:when test="${stage !='adminEdit' && section.lastSection}">
                                        <c:choose>
                                            <c:when test="${section.eventDefinitionCRF.electronicSignature == true}">
                                                <td valign="bottom">  <input type="checkbox" id="markCompleteId" name="markComplete" value="Yes"
                                                                             onclick="sm('box', this, 730,100);">
                                                </td>
                                                <td valign="bottom" nowrap="nowrap">&nbsp; <fmt:message key="mark_CRF_complete" bundle="${resword}"/>&nbsp;&nbsp;&nbsp;</td>
                                            </c:when>
                                            <c:otherwise>
                                                <td valign="bottom">  <input type="checkbox" id="markCompleteId" name="markComplete" value="Yes"
                                                                             onclick="displayMessageFromCheckbox(this, '<fmt:message key="marking_CRF_complete_finalize_DE" bundle="${restext}"/>')">
                                                </td>
                                                <td valign="bottom" nowrap="nowrap">&nbsp; <fmt:message key="mark_CRF_complete" bundle="${resword}"/>&nbsp;&nbsp;&nbsp;</td>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <td colspan="2">&nbsp;</td>
                                    </c:otherwise>
                                </c:choose>

                                   
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <!-- end of page number and buttons-->

</c:if>

<c:choose>

<c:when test="${displayItem.inGroup == true}">
<c:set var="currPage" value="${displayItem.pageNumberLabel}" />
<tr><td>
<c:set var="uniqueId" value="0"/>
<c:set var="repeatParentId" value="${displayItem.itemGroup.itemGroupBean.name}"/>

<c:set var="repeatNumber" value="${displayItem.itemGroup.groupMetaBean.repeatNum}"/>
<c:if test="${groupHasData}">
    <!-- there are already item data for an item group, repeat number just be 1-->
    <c:set var="repeatNumber" value="1"/>
</c:if>
<c:set var="repeatMax" value="${displayItem.itemGroup.groupMetaBean.repeatMax}"/>
<c:set var="totalColsPlusSubcols" value="0" />
<c:set var="questionNumber" value=""/>
    <%--the itemgroups include a group for orphaned items, in the order they should appear,
but the custom tag uses that, not this jstl code--%>
<c:if test="${! (repeatParentId eq 'Ungrouped')}">
<%-- implement group header--%>
<c:if test="${! (displayItem.itemGroup.groupMetaBean.header eq '')}">
    <div class="aka_group_header">
        <strong><c:out value="${displayItem.itemGroup.groupMetaBean.header}" escapeXml="false"/></strong>
    </div>
</c:if>
<table border="0" cellspacing="0" cellpadding="0" class="aka_form_table" width="100%">
<thead>
<tr>
        <%-- if there are horizontal checkboxes or radios anywhere in the group...--%>
    <c:set var="isHorizontal" scope="request" value="${false}"/>
    <c:forEach var="thItem" items="${displayItem.itemGroup.items}">
        <c:set var="questionNumber" value="${thItem.metadata.questionNumberLabel}"/>
        <%-- We have to add a second row of headers if the response_layout property is
     horizontal for checkboxes. --%>
        <c:set var="isHorizontalCellLevel" scope="request" value="${false}"/>
        <c:if test="${thItem.metadata.responseLayout eq 'horizontal' ||
      thItem.metadata.responseLayout eq 'Horizontal'}">
            <c:set var="isHorizontal" scope="request" value="${true}"/>
            <c:set var="isHorizontalCellLevel" scope="request" value="${true}"/>
            <c:set var="optionsLen" value="0"/>
            <c:forEach var="optn" items="${thItem.metadata.responseSet.options}">
                <c:set var="optionsLen" value="${optionsLen+1}"/>
            </c:forEach>
        </c:if>
        <c:choose>
          
            <c:when test="${isHorizontalCellLevel &&
        (thItem.metadata.responseSet.responseType.name eq 'checkbox' ||
              thItem.metadata.responseSet.responseType.name eq 'radio')}">
                <th colspan="<c:out value='${optionsLen}'/>" class="aka_headerBackground aka_padding_large aka_cellBorders">
                <%-- compute total columns value for the add button row colspan attribute--%>
                <c:set var="totalColsPlusSubcols" value="${totalColsPlusSubcols + optionsLen}" />
            </c:when>
           
            <c:otherwise>
                <th class="aka_headerBackground aka_padding_large aka_cellBorders">
                <%-- compute total columns value for the add button row colspan attribute--%>
                <c:set var="totalColsPlusSubcols" value="${totalColsPlusSubcols + 1}" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${thItem.metadata.header == ''}">
                <c:if test="${! (empty questionNumber)}">
                    <span style="margin-right:1em"><c:out value="${questionNumber}" escapeXml="false"/></span></c:if><c:out value="${thItem.metadata.leftItemText}" escapeXml="false"/>
            </c:when>
            <c:otherwise>
                <c:if test="${! (empty questionNumber)}">
                    <span style="margin-right:1em"><c:out value="${questionNumber}" escapeXml="false"/></span></c:if><c:out value="${thItem.metadata.header}" escapeXml="false"/>
            </c:otherwise>
        </c:choose>
        </th>
    </c:forEach>
    <c:if test="${displayItem.itemGroup.groupMetaBean.repeatingGroup}">
        
                <th class="aka_headerBackground aka_padding_large aka_cellBorders" />
           
    </c:if>
</tr>
<c:if test="${isHorizontal}">
    <%-- create another row --%>
    <tr>
        <c:forEach var="thItem" items="${displayItem.itemGroup.items}">
            <c:set var="isHorizontalCellLevel" scope="request" value="${false}"/>
            <c:if test="${thItem.metadata.responseLayout eq 'horizontal' ||
      thItem.metadata.responseLayout eq 'Horizontal'}">
                <c:set var="isHorizontalCellLevel" scope="request" value="${true}"/>
            </c:if>
            <c:choose>
                
                <c:when test="${isHorizontalCellLevel &&
                    (thItem.metadata.responseSet.responseType.name eq 'checkbox' ||
              thItem.metadata.responseSet.responseType.name eq 'radio')}">
                    <c:forEach var="respOpt" items="${thItem.metadata.responseSet.options}">
                        <th class="aka_headerBackground aka_padding_large aka_cellBorders">
                            <c:out value="${respOpt.text}" /></th>
                    </c:forEach>
                </c:when>
             
                <c:otherwise>
                    <th class="aka_headerBackground aka_padding_large aka_cellBorders"/>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <th />
    </tr>
</c:if>
</thead>

<tbody>

<c:set var="uniqueId" value="${0}"/>
<c:set var="repeatRowCount" value="0"/>

<c:forEach var="bodyItemGroup" items="${displayItem.itemGroups}">
    <c:set var="repeatRowCount" value="${repeatRowCount+1}"/>
</c:forEach>
<!-- there are data posted already -->
<c:if test="${repeatRowCount>1}">
    <c:set var="repeatNumber" value="1"/>
</c:if>
<!-- repeating rows in an item group  start-->
<c:forEach var="bodyItemGroup" items="${displayItem.itemGroups}"  varStatus="status">
<c:set var="columnNum"  value="1"/>
<!-- hasError is set to true when validation error happens-->
<c:choose>
<c:when test="${status.last}">
<!-- for the last but not the first row and only row, we need to use [] so the repetition javascript can copy it to create new row-->
<tr id="<c:out value="${repeatParentId}"/>" repeat="template" repeat-start="<c:out value="${repeatNumber}"/>" repeat-max="<c:out value="${repeatMax}"/>">
<c:forEach var="bodyItem" items="${bodyItemGroup.items}">
    <c:set var="itemNum" value="${itemNum + 1}" />
    <c:set var="isHorizontalCellLevel" scope="request" value="${false}"/>
    <c:if test="${bodyItem.metadata.responseLayout eq 'horizontal' ||
      bodyItem.metadata.responseLayout eq 'Horizontal'}">
        <c:set var="isHorizontalCellLevel" scope="request" value="${true}"/>
    </c:if>
    <c:choose>
        
        <c:when test="${isHorizontalCellLevel &&
                (bodyItem.metadata.responseSet.responseType.name eq 'radio' ||
           bodyItem.metadata.responseSet.responseType.name eq 'checkbox')}">
            <%-- For horizontal checkboxes, radio buttons--%>
            <c:forEach var="respOption" items="${bodyItem.metadata.responseSet.options}">
                <td class="aka_padding_norm aka_cellBorders">
                    <c:set var="displayItem" scope="request" value="${bodyItem}" />
                    <c:set var="responseOptionBean" scope="request" value="${respOption}" />
                    <c:import url="../submit/showGroupItemInputMonitor.jsp">
                        <c:param name="repeatParentId" value="${repeatParentId}"/>
                        <c:param name="rowCount" value="${uniqueId}"/>
                        <c:param name="key" value="${numOfDate}" />
                        <c:param name="isLast" value="${true}"/>
						 <c:param name="tabNum" value="${itemNum}"/>
                        <c:param name="isHorizontal" value="${isHorizontalCellLevel}"/>
                        <c:param name="defaultValue" value="${bodyItem.metadata.defaultValue}"/>
                        <c:param name="originJSP" value="initialDataEntry"/>
                        <c:param name="isLocked" value="${isLocked}"/>
                        
                    </c:import>
                </td>
            </c:forEach>
        </c:when>
       
        <%-- could be a radio or checkbox that is not horizontal --%>
        <c:otherwise>
            <td class="aka_padding_norm aka_cellBorders">
                <c:set var="displayItem" scope="request" value="${bodyItem}" />
                <c:import url="../submit/showGroupItemInputMonitor.jsp">
                    <c:param name="repeatParentId" value="${repeatParentId}"/>
                    <c:param name="rowCount" value="${uniqueId}"/>
                    <c:param name="key" value="${numOfDate}" />
                    <c:param name="isLast" value="${true}"/>
					<c:param name="tabNum" value="${itemNum}"/>
					<c:param name="defaultValue" value="${bodyItem.metadata.defaultValue}"/>
                    <c:param name="originJSP" value="initialDataEntry"/>
                    <c:param name="isLocked" value="${isLocked}"/>
                    
                </c:import>
            </td>
        </c:otherwise>
    </c:choose>
    <c:set var="columnNum" value="${columnNum+1}"/>
</c:forEach>
    <c:if test="${displayItem.itemGroup.groupMetaBean.repeatingGroup }">
       
                <td class="aka_padding_norm aka_cellBorders">
                    <input type="hidden" name="<c:out value="${repeatParentId}"/>_[<c:out value="${repeatParentId}"/>].newRow" value="yes" />
                    <button stype="remove" type="button" template="<c:out value="${repeatParentId}"/>" class="button_remove"></button>
                </td>
         
    </c:if>
</tr>

</c:when>
<c:otherwise>
<!--  not the last row -->
<tr repeat="0" />
<c:set var="columnNum"  value="1"/>
<c:forEach var="bodyItem" items="${bodyItemGroup.items}">
    <c:set var="itemNum" value="${itemNum + 1}" />
    <c:set var="isHorizontalCellLevel" scope="request" value="${false}"/>
    <c:if test="${bodyItem.metadata.responseLayout eq 'horizontal' ||
      bodyItem.metadata.responseLayout eq 'Horizontal'}">
        <c:set var="isHorizontalCellLevel" scope="request" value="${true}"/>
    </c:if>
    <c:choose>
        
        <c:when test="${isHorizontalCellLevel &&
           (bodyItem.metadata.responseSet.responseType.name eq 'radio' ||
           bodyItem.metadata.responseSet.responseType.name eq 'checkbox')}">
            <%-- For horizontal checkboxes, radio buttons--%>
            <c:forEach var="respOption" items="${bodyItem.metadata.responseSet.options}">
                <td class="aka_padding_norm aka_cellBorders">
                    <c:set var="displayItem" scope="request" value="${bodyItem}" />
                    <c:set var="responseOptionBean" scope="request" value="${respOption}" />
                    <c:import url="../submit/showGroupItemInputMonitor.jsp">
                        <c:param name="repeatParentId" value="${repeatParentId}"/>
                        <c:param name="rowCount" value="${uniqueId}"/>
                        <c:param name="key" value="${numOfDate}" />
                        <c:param name="isLast" value="${false}"/>
                        <c:param name="tabNum" value="${itemNum}"/>
                        <c:param name="isHorizontal" value="${isHorizontalCellLevel}"/>
                        <c:param name="defaultValue" value="${bodyItem.metadata.defaultValue}"/>
                        <c:param name="originJSP" value="initialDataEntry"/>
                        <c:param name="isLocked" value="${isLocked}"/>
						
                    </c:import>
                </td>
            </c:forEach>
        </c:when>
      
        <%-- could be a radio or checkbox that is not horizontal --%>
        <c:otherwise>
            <td class="aka_padding_norm aka_cellBorders">
                <c:set var="displayItem" scope="request" value="${bodyItem}" />
                <c:import url="../submit/showGroupItemInputMonitor.jsp">
                    <c:param name="repeatParentId" value="${repeatParentId}"/>
                    <c:param name="rowCount" value="${uniqueId}"/>
                    <c:param name="key" value="${numOfDate}" />
                    <c:param name="isLast" value="${false}"/>
                    <c:param name="tabNum" value="${itemNum}"/>
                    <c:param name="defaultValue" value="${bodyItem.metadata.defaultValue}"/>
                    <c:param name="originJSP" value="initialDataEntry"/>
                    <c:param name="isLocked" value="${isLocked}"/>
					
                </c:import>
            </td>
        </c:otherwise>
    </c:choose>
    <c:set var="columnNum" value="${columnNum+1}"/>
</c:forEach>
    <c:if test="${displayItem.itemGroup.groupMetaBean.repeatingGroup }">
     
                <td class="aka_padding_norm aka_cellBorders">
                        <%-- check for manual in the input name; if rowCount > 0 then manual
                   will be in the name --%>
                    <c:choose>
                        <c:when test="${uniqueId ==0}">
                            <input type="hidden" name="<c:out value="${repeatParentId}"/>_<c:out value="${uniqueId}"/>.newRow" value="yes">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="<c:out value="${repeatParentId}"/>_manual<c:out value="${uniqueId}"/>.newRow" value="yes">
                        </c:otherwise>
                    </c:choose>
                    <button stype="remove" type="button" template="<c:out value="${repeatParentId}"/>" class="button_remove"></button>
                </td>
           
    </c:if>
</tr>
</c:otherwise>
</c:choose>
<c:set var="uniqueId" value="${uniqueId +1}"/>
<!-- repeating rows in an item group end -->
</c:forEach>
    <c:if test="${displayItem.itemGroup.groupMetaBean.repeatingGroup }">
        <tr><td class="aka_padding_norm aka_cellBorders" colspan="<c:out value="${totalColsPlusSubcols + 1}"/>">
                        <button stype="add" type="button" template="<c:out value="${repeatParentId}"/>" class="button_search"><fmt:message key="add" bundle="${resword}"/></button></td>
               
        </tr>
    </c:if>
</tbody>

</table>
<%--test for itemgroup named Ungrouped --%>
</c:if>
</td></tr>


</c:when>

<c:otherwise>


<c:set var="currPage" value="${displayItem.singleItem.metadata.pageNumberLabel}" />

    <%-- SHOW THE PARENT FIRST --%>
<c:if test="${displayItem.singleItem.metadata.parentId == 0}">

<!--ACCORDING TO COLUMN NUMBER, ARRANGE QUESTIONS IN THE SAME LINE-->

<c:if test="${displayItem.singleItem.metadata.columnNumber <=1}">
<c:if test="${numOfTr > 0 }">
</tr>
</table>
</td>

</tr>

</c:if>
<c:set var="numOfTr" value="${numOfTr+1}"/>
<c:if test="${!empty displayItem.singleItem.metadata.header}">
    <tr class="aka_stripes">
            <%--<td class="table_cell_left" bgcolor="#F5F5F5">--%>
        <td class="table_cell_left aka_stripes"><b><c:out value=
          "${displayItem.singleItem.metadata.header}" escapeXml="false"/></b></td>
    </tr>
</c:if>
<c:if test="${!empty displayItem.singleItem.metadata.subHeader}">
    <tr class="aka_stripes">
        <td class="table_cell_left"><c:out value="${displayItem.singleItem.metadata.subHeader}" escapeXml=
          "false"/></td>
    </tr>
</c:if>
<tr>
    <td class="table_cell_left">
        <table border="0" >
            <tr>
                <td valign="top">
                    </c:if>

                    <c:if test="${displayItem.singleItem.metadata.columnNumber >1}">
                <td valign="top">
                    </c:if>
                    <table border="0">
                        <tr>
                            <td valign="top" class="aka_ques_block"><c:out value="${displayItem.singleItem.metadata.questionNumberLabel}" escapeXml="false"/></td>
                            <td valign="top" class="aka_text_block"><c:out value="${displayItem.singleItem.metadata.leftItemText}" escapeXml="false"/></td>

                            <td valign="top" nowrap="nowrap">
                                    <%-- display the HTML input tag --%>
                                <c:set var="displayItem" scope="request" value="${displayItem.singleItem}" />
                                <c:import url="../submit/showItemInputMonitor.jsp">
                                    <c:param name="key" value="${numOfDate}" />
                                    <c:param name="tabNum" value="${itemNum}"/>
                                    <%-- add default value from the crf --%>
                                    <c:param name="defaultValue" value="${displayItem.singleItem.metadata.defaultValue}"/>
                                    <c:param name="respLayout" value="${displayItem.singleItem.metadata.responseLayout}"/>
                                    <c:param name="originJSP" value="initialDataEntry"/>
                                    <c:param name="isLocked" value="${isLocked}"/>
                                </c:import>

                            </td>
                            <c:if test='${displayItem.singleItem.item.units != ""}'>
                                <td valign="top">
                                    <c:out value="(${displayItem.singleItem.item.units})" escapeXml="false"/>
                                </td>
                            </c:if>
                            <td valign="top"><c:out value="${displayItem.singleItem.metadata.rightItemText}" escapeXml="false" /></td>
                        </tr>
                            <%--try this, displaying error messages in their own row--%>
                            <%--We won't need this if the error messages are not embedded in the form:
                            <tr>
                              <td valign="top" colspan="4" style="text-align:right">
                                <c:import url="../showMessage.jsp"><c:param name="key" value=
                                  "input${displayItem.singleItem.item.id}" /></c:import> </td>
                            </tr>--%>
                    </table>
                </td>
                <c:if test="${itemStatus.last}">
            </tr>
        </table>
    </td>

</tr>
</c:if>

<c:if test="${displayItem.singleItem.numChildren > 0}">
    <tr>
            <%-- indentation --%>
        <!--<td class="table_cell">&nbsp;</td>-->
            <%-- NOW SHOW THE CHILDREN --%>

        <td class="table_cell">
            <table border="0">
                <c:set var="notFirstRow" value="${0}" />
                <c:forEach var="childItem" items="${displayItem.singleItem.children}">


                <c:set var="currColumn" value="${childItem.metadata.columnNumber}" />
                <c:if test="${currColumn == 1}">
                <c:if test="${notFirstRow != 0}">
                    </tr>
                </c:if>
                <tr>
                    <c:set var="notFirstRow" value="${1}" />
                        <%-- indentation --%>
                    <td valign="top">&nbsp;</td>
                    </c:if>
                        <%--
                          this for loop "fills in" columns left blank
                          e.g., if the first childItem has column number 2, and the next one has column number 5,
                          then we need to insert one blank column before the first childItem, and two blank columns between the second and third children
                        --%>
                    <c:forEach begin="${currColumn}" end="${childItem.metadata.columnNumber}">
                        <td valign="top">&nbsp;</td>
                    </c:forEach>

                    <td valign="top">
                        <table border="0">
                            <tr>
                                    <%--          <td valign="top" class="text_block">
                                  <c:out value="${childItem.metadata.questionNumberLabel}" escapeXml="false"/>
                                  <c:out value="${childItem.metadata.leftItemText}" escapeXml="false"/></td>--%>
                                <td valign="top" class="aka_ques_block"><c:out value="${childItem.metadata.questionNumberLabel}" escapeXml="false"/></td>
                                <td valign="top" class="aka_text_block"><c:out value="${childItem.metadata.leftItemText}" escapeXml="false"/></td>
                                <td valign="top" nowrap="nowrap">
                                        <%-- display the HTML input tag --%>
                                    <c:set var="itemNum" value="${itemNum + 1}" />
                                    <c:set var="displayItem" scope="request" value="${childItem}" />
                                    <c:import url="../submit/showItemInputMonitor.jsp" >
                                        <c:param name="key" value="${numOfDate}" />
                                        <c:param name="tabNum" value="${itemNum}"/>
                                        <c:param name="defaultValue" value="${childItem.metadata.defaultValue}"/>
                                        <c:param name="respLayout" value="${childItem.metadata.responseLayout}"/>
                                        <c:param name="originJSP" value="initialDataEntry"/>
                                        <c:param name="isLocked" value="${isLocked}"/>
										
                                    </c:import>
                                        <%--	<br />--%><%--<c:import url="../showMessage.jsp"><c:param name="key" value="input${childItem.item.id}" /></c:import>--%>
                                </td>
                                <c:if test='${childItem.item.units != ""}'>
                                    <td valign="top"> <c:out value="(${childItem.item.units})" escapeXml="false"/> </td>
                                </c:if>
                                <td valign="top"> <c:out value="${childItem.metadata.rightItemText}" escapeXml="false"/> </td>
                            </tr>
                                <%--BWP: try this--%>
                            <tr>
                                <td valign="top" colspan="4" style="text-align:right">
                                    <c:import url="../showMessage.jsp"><c:param name="key" value=
                                      "input${childItem.item.id}" /></c:import> </td>
                            </tr>
                        </table>
                    </td>
                    </c:forEach>
                </tr>
            </table>
        </td>
    </tr>
</c:if>
</c:if>

</c:otherwise>
    <%--end comment here to see problem with this part of the JSP, and
  include an <c:otherwise></c:otherwise>--%>

</c:choose>

<c:set var="displayItemNum" value="${displayItemNum + 1}" />
<c:set var="itemNum" value="${itemNum + 1}" />

</c:forEach>
</table>


<!-- End Table Contents -->


</div>
</div>
</div></div></div></div></div></div></div></div>
</div>
<div class="clinexia-form-card clinexia-form-toolbar-card clinexia-form-toolbar-card-bottom">
    <div class="clinexia-form-actions">
        <c:choose>
            <c:when test="${!empty exitTo && exitTo != 'none'}">
                <input type="button" onclick="window.location = '<c:out value="${exitTo}"/>'" value="Cancel" class="button_medium clinexia-secondary-button"/>
            </c:when>
            <c:when test="${studySubjectId > 0}">
                <input type="button" onclick="window.location = 'ViewStudySubject?id=<c:out value="${studySubjectId}"/>';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
            </c:when>
            <c:when test="${eventId > 0}">
                <input type="button" onclick="window.location = 'EnterDataForStudyEvent?eventId=<c:out value="${eventId}"/>';" name="exit" value="Cancel" class="button_medium clinexia-secondary-button"/>
            </c:when>
        </c:choose>
        <button type="submit" name="submittedResume" value="Save" class="button_medium clinexia-primary-submit" onclick="clinexiaClearCompleteIntent();">Save</button>
        <c:if test="${stage != 'adminEdit' && section.lastSection}">
            <button type="submit" name="submittedResume" value="Save" class="button_medium clinexia-complete-submit" onclick="return clinexiaPrepareComplete();">Complete Visit</button>
        </c:if>
    </div>
    <div class="clinexia-form-toolbar-meta">
        <span class="clinexia-form-hint">You're working in section <c:out value="${tabId}" /> of <c:out value="${sectionNum}" />.</span>
    </div>
</div>
</div>
</form>

</div>
<div id="testdiv1" style=
  "position:absolute;visibility:hidden;background-color:white"></div>
<script type="text/javascript">
function clinexiaEnsureHiddenField(name, value) {
    var form = document.getElementById('mainForm');
    var inputs;
    var field = null;
    var i;
    if (!form) {
        return null;
    }
    inputs = form.getElementsByTagName('input');
    for (i = 0; i < inputs.length; i++) {
        if (inputs[i].type === 'hidden' && inputs[i].name === name) {
            field = inputs[i];
            break;
        }
    }
    if (!field) {
        field = document.createElement('input');
        field.type = 'hidden';
        field.name = name;
        form.appendChild(field);
    }
    field.value = value;
    return field;
}

function clinexiaClearCompleteIntent() {
    var field = clinexiaEnsureHiddenField('markComplete', '');
    if (field) {
        field.value = '';
    }
    return true;
}

function clinexiaPrepareComplete() {
    clinexiaEnsureHiddenField('markComplete', 'Yes');
    return true;
}

function clinexiaSanitizeLabel(label, fallback) {
    if (!label) {
        return fallback || 'Section';
    }
    var clean = label.replace(/^\s+|\s+$/g, '');
    if (/^SEC[_\-\s]/i.test(clean) || /^OID[:\s]/i.test(clean)) {
        return fallback || 'Section';
    }
    return clean;
}

function clinexiaApplyFieldPlaceholders() {
    var form = document.getElementById('mainForm');
    var inputs;
    var textareas;
    var fields = [];
    var i;
    var row;
    var rowCells;
    var labelText;
    var field;
    if (!form) {
        return;
    }
    inputs = form.getElementsByTagName('input');
    textareas = form.getElementsByTagName('textarea');
    for (i = 0; i < inputs.length; i++) {
        if (inputs[i].type === 'text') {
            fields.push(inputs[i]);
        }
    }
    for (i = 0; i < textareas.length; i++) {
        fields.push(textareas[i]);
    }
    for (var i = 0; i < fields.length; i++) {
        field = fields[i];
        if (field.getAttribute('placeholder')) {
            continue;
        }
        row = field;
        while (row && row.tagName && row.tagName.toLowerCase() !== 'tr') {
            row = row.parentNode;
        }
        labelText = '';
        if (row) {
            rowCells = row.getElementsByTagName('td');
            for (var j = 0; j < rowCells.length; j++) {
                if ((' ' + rowCells[j].className + ' ').indexOf(' aka_text_block ') > -1) {
                    labelText = (rowCells[j].textContent || rowCells[j].innerText || '').replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
                    break;
                }
            }
        }
        if (!labelText && field.name === 'interviewer') {
            labelText = 'Interviewer name';
        }
        if (!labelText && field.name === 'interviewDate') {
            labelText = 'Enrollment date';
        }
        if (labelText) {
            field.setAttribute('placeholder', labelText);
        }
    }
}

function clinexiaPolishSectionLabels() {
    var tabs = document.querySelectorAll('.crfHeaderTabs .tabtext, .clinexia-section-name, select[name="sectionSelect"] option');
    var node;
    var fallback;
    for (var i = 0; i < tabs.length; i++) {
        node = tabs[i];
        fallback = 'Section ' + (i + 1);
        var clean = clinexiaSanitizeLabel(node.textContent || node.innerText, fallback);
        if (node.tagName && node.tagName.toLowerCase() === 'option') {
            node.text = clean;
        } else {
            node.textContent = clean;
        }
    }
    var infoLabels = document.querySelectorAll('#CRF_infobox_closed b, #CRF_infobox_open b');
    for (var j = 0; j < infoLabels.length; j++) {
        infoLabels[j].textContent = 'Form details';
    }
    var markCompleteInputs = document.getElementsByName('markComplete');
    for (var k = 0; k < markCompleteInputs.length; k++) {
        var checkboxCell = markCompleteInputs[k].parentNode;
        var labelCell = checkboxCell ? checkboxCell.nextSibling : null;
        if (checkboxCell && checkboxCell.style) {
            checkboxCell.style.display = 'none';
        }
        while (labelCell && labelCell.nodeType !== 1) {
            labelCell = labelCell.nextSibling;
        }
        if (labelCell && labelCell.style) {
            labelCell.style.display = 'none';
        }
    }
}

function clinexiaSyncSaveState() {
    var badge = document.getElementById('clinexiaFormSaveState');
    if (!badge) {
        return;
    }
    var statusImage = document.getElementById('status_top') || document.getElementById('status_bottom');
    var unsaved = statusImage && statusImage.src && statusImage.src.indexOf('icon_UnsavedData') > -1;
    badge.className = 'clinexia-feedback-badge ' + (unsaved ? 'is-unsaved' : 'is-saved');
    badge.innerHTML = unsaved ? 'Unsaved changes' : 'All changes saved';
}

function clinexiaInitFormExperience() {
    clinexiaApplyFieldPlaceholders();
    clinexiaPolishSectionLabels();
    clinexiaSyncSaveState();
    window.setInterval(clinexiaSyncSaveState, 800);
}
</script>
</body>
</html>
