<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<c:set var="dteFormat"><fmt:message key="date_format_string" bundle="${resformat}"/></c:set>

<c:choose>
    <c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
        <c:import url="../include/admin-header.jsp"/>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${userRole.manageStudy && module=='manage'}">
                <c:import url="../include/managestudy-header.jsp"/>
            </c:when>
            <c:otherwise>
                <c:import url="../include/submit-header.jsp"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>

<script type="text/JavaScript" language="JavaScript" src="includes/jmesa/jquery.min.js"></script>
<script type="text/javascript" language="JavaScript" src="includes/jmesa/jquery-migrate-1.1.1.js"></script>
<script type="text/javascript" language="javascript">

    function studySubjectResource()  { return "${study.oid}/${studySub.oid}"; }

    function checkCRFLocked(ecId, url){
        jQuery.post("CheckCRFLocked?ecId="+ ecId + "&ran="+Math.random(), function(data){
            if(data == 'true'){
                window.location = url;
            }else{
                alert(data);return false;
            }
        });
    }
    function checkCRFLockedInitial(ecId, formName){
        if(ecId==0) {formName.submit(); return;}
        jQuery.post("CheckCRFLocked?ecId="+ ecId + "&ran="+Math.random(), function(data){
            if(data == 'true'){
                formName.submit();
            }else{
                alert(data);
            }
        });
    }
</script>

<!-- move the alert message to the sidebar-->
<jsp:include page="../include/sideAlert.jsp"/>
<!-- then instructions-->
<tr id="sidebar_Instructions_open" style="display: none">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_collapse.gif" border="0" align="right" hspace="10"></a>

        <b><fmt:message key="instructions" bundle="${restext}"/></b>

        <div class="sidebar_tab_content">
        </div>

    </td>

</tr>
<tr id="sidebar_Instructions_closed" style="display: all">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><img src="images/sidebar_expand.gif" border="0" align="right" hspace="10"></a>

        <b><fmt:message key="instructions" bundle="${restext}"/></b>

    </td>
</tr>
<jsp:include page="../include/sideInfo.jsp"/>

<jsp:useBean scope="request" id="subject" class="org.akaza.openclinica.bean.submit.SubjectBean"/>
<jsp:useBean scope="request" id="subjectStudy" class="org.akaza.openclinica.bean.managestudy.StudyBean"/>
<jsp:useBean scope="request" id="parentStudy" class="org.akaza.openclinica.bean.managestudy.StudyBean"/>
<jsp:useBean scope="request" id="studySub" class="org.akaza.openclinica.bean.managestudy.StudySubjectBean"/>
<jsp:useBean scope="request" id="children" class="java.util.ArrayList"/>
<jsp:useBean scope='request' id='table' class='org.akaza.openclinica.web.bean.EntityBeanTable'/>
<jsp:useBean scope="request" id="groups" class="java.util.ArrayList"/>
<jsp:useBean scope="request" id="from" class="java.lang.String"/>

<c:set var="visitCount" value="${fn:length(table.rows)}" />
<c:set var="associatedStudyName" value="${subjectStudy.name}" />
<c:if test="${empty associatedStudyName}">
    <c:set var="associatedStudyName" value="${parentStudy.name}" />
</c:if>
<c:set var="patientStatusToken" value="${fn:toLowerCase(studySub.status.name)}" />
<c:set var="patientStatusLabel" value="Screened" />
<c:if test="${fn:contains(patientStatusToken, 'available') || fn:contains(patientStatusToken, 'active')}">
    <c:set var="patientStatusLabel" value="Active" />
</c:if>
<c:if test="${fn:contains(patientStatusToken, 'completed') || fn:contains(patientStatusToken, 'signed')}">
    <c:set var="patientStatusLabel" value="Completed" />
</c:if>
<c:set var="incompleteFormsCount" value="0" />
<c:set var="visitsWithPendingCount" value="0" />
<c:set var="nextPatientActionUrl" value="" />
<c:set var="nextPatientActionLabel" value="Review patient summary" />
<c:forEach var="summaryRow" items="${table.rows}">
    <c:set var="visitPendingForms" value="${fn:length(summaryRow.bean.uncompletedCRFs)}" />
    <c:forEach var="summaryUncompleted" items="${summaryRow.bean.uncompletedCRFs}">
        <c:if test="${empty nextPatientActionUrl}">
            <c:set var="nextPatientActionUrl" value="ViewSectionDataEntry?eventDefinitionCRFId=${summaryUncompleted.edc.id}&crfVersionId=${summaryUncompleted.edc.defaultVersionId}&tabId=1&studySubjectId=${studySub.id}&ecId=${summaryUncompleted.eventCRF.id}&exitTo=ViewStudySubject?id=${studySub.id}" />
            <c:set var="nextPatientActionLabel" value="Open next visit" />
        </c:if>
    </c:forEach>
    <c:forEach var="summaryDec" items="${summaryRow.bean.displayEventCRFs}">
        <c:if test="${empty nextPatientActionUrl && !(summaryDec.stage.locked || summaryDec.eventCRF.status.locked || summaryDec.locked || summaryDec.stage.initialDE_Complete || summaryDec.stage.doubleDE_Complete)}">
            <c:set var="nextPatientActionUrl" value="ViewSectionDataEntry?ecId=${summaryDec.eventCRF.id}&eventDefinitionCRFId=${summaryDec.eventDefinitionCRF.id}&tabId=1&studySubjectId=${studySub.id}&exitTo=ViewStudySubject?id=${studySub.id}" />
            <c:set var="nextPatientActionLabel" value="Open next visit" />
        </c:if>
        <c:if test="${!(summaryDec.stage.locked || summaryDec.eventCRF.status.locked || summaryDec.locked || summaryDec.stage.initialDE_Complete || summaryDec.stage.doubleDE_Complete)}">
            <c:set var="visitPendingForms" value="${visitPendingForms + 1}" />
        </c:if>
    </c:forEach>
    <c:set var="incompleteFormsCount" value="${incompleteFormsCount + visitPendingForms}" />
    <c:if test="${visitPendingForms > 0}">
        <c:set var="visitsWithPendingCount" value="${visitsWithPendingCount + 1}" />
    </c:if>
</c:forEach>
<c:set var="patientAlertToneClass" value="is-success" />
<c:if test="${incompleteFormsCount > 0}">
    <c:set var="patientAlertToneClass" value="is-warning" />
</c:if>
<c:set var="canConfigureVisitForms" value="${userRole.coordinator || userRole.director || userBean.sysAdmin || userBean.techAdmin}" />
<c:set var="visitConfigUrl" value="" />
<c:if test="${userRole.coordinator || userRole.director}">
    <c:choose>
        <c:when test="${!(study.parentStudyId > 0 && (userRole.coordinator || userRole.director))}">
            <c:set var="visitConfigUrl" value="pages/studymodule" />
        </c:when>
        <c:otherwise>
            <c:set var="visitConfigUrl" value="ViewStudy?id=${study.id}&viewFull=yes" />
        </c:otherwise>
    </c:choose>
</c:if>
<c:if test="${empty visitConfigUrl && (userBean.sysAdmin || userBean.techAdmin)}">
    <c:set var="visitConfigUrl" value="ListCRF?module=admin" />
</c:if>
<c:if test="${visitCount == 0}">
    <c:set var="nextPatientActionUrl" value="CreateNewStudyEvent?studySubjectId=${studySub.id}&autostart=baseline" />
    <c:set var="nextPatientActionLabel" value="Start first visit" />
</c:if>
<c:if test="${empty nextPatientActionUrl && canConfigureVisitForms && not empty visitConfigUrl}">
    <c:set var="nextPatientActionUrl" value="${visitConfigUrl}" />
    <c:set var="nextPatientActionLabel" value="Assign forms to visits" />
</c:if>

<div class="clinexia-patient-shell">
    <section class="clinexia-patient-hero">
        <div class="clinexia-patient-hero-copy">
            <span class="clinexia-section-kicker">Patient Overview</span>
            <h1 class="clinexia-patient-title"><c:out value="${studySub.label}"/></h1>
            <div class="clinexia-patient-meta">
                <span class="clinexia-status-badge
                    <c:choose>
                        <c:when test="${fn:contains(patientStatusToken, 'available') || fn:contains(patientStatusToken, 'active')}">clinexia-status-badge-active</c:when>
                        <c:when test="${fn:contains(patientStatusToken, 'completed') || fn:contains(patientStatusToken, 'signed')}">clinexia-status-badge-completed</c:when>
                        <c:otherwise>clinexia-status-badge-screened</c:otherwise>
                    </c:choose>
                "><c:out value="${patientStatusLabel}"/></span>
                <span class="clinexia-patient-site">Study <strong><c:out value="${associatedStudyName}"/></strong></span>
            </div>
            <div class="clinexia-patient-header-facts">
                <span><strong>Status</strong> <c:out value="${patientStatusLabel}"/></span>
                <span><strong>Study</strong> <c:out value="${associatedStudyName}"/></span>
                <span><strong>Visits</strong> <c:out value="${visitCount}" /></span>
            </div>
        </div>
        <div class="clinexia-patient-hero-actions">
            <c:if test="${study.status.available && !userRole.monitor}">
                <a class="clinexia-table-action" href="UpdateStudySubject?id=<c:out value='${studySub.id}'/>&amp;action=show">Edit Patient</a>
            </c:if>
            <c:if test="${not empty nextPatientActionUrl}">
                <a class="clinexia-table-action clinexia-visit-action clinexia-hero-primary-action" href="<c:out value='${nextPatientActionUrl}'/>"><c:out value="${nextPatientActionLabel}"/></a>
            </c:if>
        </div>
    </section>

    <section class="clinexia-feedback-strip">
        <article class="clinexia-feedback-tile is-status">
            <span class="clinexia-feedback-kicker">Patient status</span>
            <strong><c:out value="${patientStatusLabel}"/></strong>
            <span>Current lifecycle stage for this patient record.</span>
        </article>
        <article class="clinexia-feedback-tile ${patientAlertToneClass}">
            <span class="clinexia-feedback-kicker">Alerts</span>
            <strong>
                <c:choose>
                    <c:when test="${incompleteFormsCount > 0}"><c:out value="${incompleteFormsCount}"/> forms need attention</c:when>
                    <c:otherwise>All forms are up to date</c:otherwise>
                </c:choose>
            </strong>
            <span>
                <c:choose>
                    <c:when test="${visitsWithPendingCount > 0}">Across <c:out value="${visitsWithPendingCount}"/> visits in the current timeline.</c:when>
                    <c:otherwise>No open tasks remain in this patient flow.</c:otherwise>
                </c:choose>
            </span>
        </article>
        <article class="clinexia-feedback-tile is-info">
            <span class="clinexia-feedback-kicker">Next step</span>
            <strong>
                <c:choose>
                    <c:when test="${visitCount == 0}">Start the first visit</c:when>
                    <c:when test="${incompleteFormsCount > 0}">Continue the next active visit</c:when>
                    <c:otherwise>Review the completed timeline</c:otherwise>
                </c:choose>
            </strong>
            <span>
                <c:choose>
                    <c:when test="${not empty nextPatientActionUrl}">
                        <a class="clinexia-feedback-link" href="<c:out value='${nextPatientActionUrl}'/>"><c:out value="${nextPatientActionLabel}"/></a>
                    </c:when>
                    <c:otherwise>Every visit card includes a direct action so the next step is always obvious.</c:otherwise>
                </c:choose>
            </span>
        </article>
    </section>

    <div class="clinexia-patient-layout">
        <div class="clinexia-patient-main">
            <section class="clinexia-patient-card">
                <div class="clinexia-patient-card-header">
                    <div>
                        <span class="clinexia-section-kicker">Visits</span>
                        <h2>Patient timeline</h2>
                        <p>Track each visit and open the assigned forms from one place.</p>
                    </div>
                    <div class="clinexia-patient-summary">
                        <strong><c:out value="${visitCount}" /></strong>
                        <span>Visits in this patient record</span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${visitCount > 0}">
                        <div class="clinexia-visit-timeline">
                            <c:forEach var="row" items="${table.rows}">
                                <c:set var="visitStatusToken" value="${fn:toLowerCase(row.bean.studyEvent.subjectEventStatus.name)}" />
                                <c:set var="visitActionUrl" value="" />
                                <c:set var="visitFallbackUrl" value="" />
                                <c:set var="visitCardUrl" value="" />
                                <c:set var="visitStateLabel" value="Scheduled" />
                                <c:set var="visitStateClass" value="clinexia-status-badge-screened" />
                                <c:set var="visitActionHint" value="Ready to start this visit" />
                                <c:set var="totalFormsInVisit" value="${fn:length(row.bean.uncompletedCRFs) + fn:length(row.bean.displayEventCRFs)}" />
                                <c:set var="completedFormsInVisit" value="0" />
                                <c:set var="pendingFormsInVisit" value="${fn:length(row.bean.uncompletedCRFs)}" />
                                <c:if test="${fn:contains(visitStatusToken, 'completed') || fn:contains(visitStatusToken, 'signed') || fn:contains(visitStatusToken, 'stopped')}">
                                    <c:set var="visitStateLabel" value="Completed" />
                                    <c:set var="visitStateClass" value="clinexia-status-badge-completed" />
                                    <c:set var="visitActionHint" value="Review completed forms and visit history" />
                                </c:if>
                                <c:if test="${fn:contains(visitStatusToken, 'data entry started') || fn:contains(visitStatusToken, 'started') || fn:contains(visitStatusToken, 'in progress')}">
                                    <c:set var="visitStateLabel" value="In progress" />
                                    <c:set var="visitStateClass" value="clinexia-status-badge-active" />
                                    <c:set var="visitActionHint" value="Continue work on this visit" />
                                </c:if>
                                <c:if test="${fn:contains(visitStatusToken, 'scheduled') || fn:contains(visitStatusToken, 'available')}">
                                    <c:set var="visitStateLabel" value="Scheduled" />
                                    <c:set var="visitStateClass" value="clinexia-status-badge-screened" />
                                    <c:set var="visitActionHint" value="Open this visit and begin data capture" />
                                </c:if>
                                <c:forEach var="dedc" items="${row.bean.uncompletedCRFs}">
                                    <c:if test="${empty visitActionUrl}">
                                        <c:set var="visitActionUrl" value="ViewSectionDataEntry?eventDefinitionCRFId=${dedc.edc.id}&crfVersionId=${dedc.edc.defaultVersionId}&tabId=1&studySubjectId=${studySub.id}&ecId=${dedc.eventCRF.id}&exitTo=ViewStudySubject?id=${studySub.id}" />
                                    </c:if>
                                </c:forEach>
                                <c:forEach var="dec" items="${row.bean.displayEventCRFs}">
                                    <c:if test="${empty visitFallbackUrl}">
                                        <c:set var="visitFallbackUrl" value="ViewSectionDataEntry?ecId=${dec.eventCRF.id}&eventDefinitionCRFId=${dec.eventDefinitionCRF.id}&tabId=1&studySubjectId=${studySub.id}&exitTo=ViewStudySubject?id=${studySub.id}" />
                                    </c:if>
                                    <c:if test="${empty visitActionUrl && !(dec.stage.locked || dec.eventCRF.status.locked || dec.locked || dec.stage.initialDE_Complete || dec.stage.doubleDE_Complete)}">
                                        <c:set var="visitActionUrl" value="ViewSectionDataEntry?ecId=${dec.eventCRF.id}&eventDefinitionCRFId=${dec.eventDefinitionCRF.id}&tabId=1&studySubjectId=${studySub.id}&exitTo=ViewStudySubject?id=${studySub.id}" />
                                    </c:if>
                                    <c:if test="${dec.stage.locked || dec.eventCRF.status.locked || dec.locked || dec.stage.initialDE_Complete || dec.stage.doubleDE_Complete}">
                                        <c:set var="completedFormsInVisit" value="${completedFormsInVisit + 1}" />
                                    </c:if>
                                    <c:if test="${!(dec.stage.locked || dec.eventCRF.status.locked || dec.locked || dec.stage.initialDE_Complete || dec.stage.doubleDE_Complete)}">
                                        <c:set var="pendingFormsInVisit" value="${pendingFormsInVisit + 1}" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty visitActionUrl && not empty visitFallbackUrl}">
                                    <c:set var="visitActionUrl" value="${visitFallbackUrl}" />
                                </c:if>
                                <c:if test="${not empty visitActionUrl}">
                                    <c:set var="visitCardUrl" value="${visitActionUrl}" />
                                </c:if>
                                <c:if test="${empty visitCardUrl && canConfigureVisitForms && not empty visitConfigUrl}">
                                    <c:set var="visitCardUrl" value="${visitConfigUrl}" />
                                </c:if>
                                <c:set var="visitCompletionPercent" value="0" />
                                <c:if test="${totalFormsInVisit > 0}">
                                    <fmt:parseNumber var="visitCompletionPercent" integerOnly="true" value="${(completedFormsInVisit * 100) / totalFormsInVisit}" />
                                </c:if>
                                <article class="clinexia-visit-card">
                                    <div class="clinexia-visit-marker"></div>
                                    <div class="clinexia-visit-body">
                                        <div class="clinexia-visit-header">
                                            <div>
                                                <h3>
                                                    <c:out value="${row.bean.studyEvent.studyEventDefinition.name}"/>
                                                    <c:if test="${row.bean.studyEvent.studyEventDefinition.repeating}">
                                                        <span class="clinexia-visit-occurrence">Visit <c:out value="${row.bean.studyEvent.sampleOrdinal}"/></span>
                                                    </c:if>
                                                </h3>
                                                <div class="clinexia-visit-submeta">
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${row.bean.studyEvent.dateStarted != null}">
                                                                <fmt:formatDate value="${row.bean.studyEvent.dateStarted}" pattern="${dteFormat}"/>
                                                            </c:when>
                                                            <c:otherwise>Not scheduled yet</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <c:if test="${not empty row.bean.studyEvent.location}">
                                                        <span><c:out value="${row.bean.studyEvent.location}"/></span>
                                                    </c:if>
                                                </div>
                                                <div class="clinexia-visit-action-copy"><c:out value="${visitActionHint}"/></div>
                                            </div>
                                            <div class="clinexia-visit-header-actions">
                                                <span class="clinexia-status-badge ${visitStateClass}"><c:out value="${visitStateLabel}"/></span>
                                                <c:if test="${pendingFormsInVisit > 0}">
                                                    <span class="clinexia-inline-alert"><c:out value="${pendingFormsInVisit}"/> forms pending</span>
                                                </c:if>
                                                <c:if test="${not empty visitCardUrl}">
                                                    <a class="clinexia-table-action clinexia-visit-action" href="<c:out value='${visitCardUrl}'/>">Open Visit</a>
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="clinexia-visit-progress">
                                            <div class="clinexia-visit-progress-copy">
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${totalFormsInVisit > 0}">
                                                            <c:out value="${completedFormsInVisit}" /> of <c:out value="${totalFormsInVisit}" /> forms completed
                                                        </c:when>
                                                        <c:otherwise>No forms assigned</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${totalFormsInVisit > 0}">
                                                            Progress for this visit
                                                        </c:when>
                                                        <c:otherwise>This visit is available but has no assigned forms yet.</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="clinexia-progress-track clinexia-visit-progress-track" aria-hidden="true">
                                                <span class="clinexia-progress-bar clinexia-visit-progress-bar" style="width: <c:out value='${visitCompletionPercent}'/>%;"></span>
                                            </div>
                                        </div>

                                        <div class="clinexia-visit-forms">
                                            <c:forEach var="dedc" items="${row.bean.uncompletedCRFs}">
                                                <div class="clinexia-form-row clinexia-form-row-pending">
                                                    <div>
                                                        <span class="clinexia-form-name"><c:out value="${dedc.edc.crf.name}" /></span>
                                                        <span class="clinexia-form-state">Pending</span>
                                                    </div>
                                                    <a class="clinexia-table-action" href="ViewSectionDataEntry?eventDefinitionCRFId=<c:out value='${dedc.edc.id}'/>&crfVersionId=<c:out value='${dedc.edc.defaultVersionId}'/>&tabId=1&studySubjectId=<c:out value='${studySub.id}'/>&ecId=<c:out value='${dedc.eventCRF.id}'/>&exitTo=ViewStudySubject?id=${studySub.id}">Open Form</a>
                                                </div>
                                            </c:forEach>

                                            <c:forEach var="dec" items="${row.bean.displayEventCRFs}">
                                                <c:set var="formStageToken" value="${fn:toLowerCase(dec.stage.name)}" />
                                                <div class="clinexia-form-row
                                                    <c:choose>
                                                        <c:when test="${dec.stage.locked || dec.eventCRF.status.locked || dec.locked || dec.stage.initialDE_Complete || dec.stage.doubleDE_Complete}">clinexia-form-row-completed</c:when>
                                                        <c:otherwise>clinexia-form-row-pending</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    <div>
                                                        <span class="clinexia-form-name"><c:out value="${dec.eventCRF.crf.name}" /></span>
                                                        <span class="clinexia-form-state">
                                                            <c:choose>
                                                                <c:when test="${dec.stage.locked || dec.eventCRF.status.locked || dec.locked}">Locked</c:when>
                                                                <c:when test="${dec.stage.initialDE_Complete || dec.stage.doubleDE_Complete}">Completed</c:when>
                                                                <c:when test="${dec.stage.initialDE || dec.stage.doubleDE || dec.stage.admin_Editing || fn:contains(formStageToken, 'initial') || fn:contains(formStageToken, 'double')}">In progress</c:when>
                                                                <c:otherwise><c:out value="${dec.stage.name}" /></c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <a class="clinexia-table-action" href="ViewSectionDataEntry?ecId=<c:out value='${dec.eventCRF.id}'/>&eventDefinitionCRFId=<c:out value='${dec.eventDefinitionCRF.id}'/>&tabId=1&studySubjectId=<c:out value='${studySub.id}'/>&exitTo=ViewStudySubject?id=${studySub.id}">Open Form</a>
                                                </div>
                                            </c:forEach>

                                            <c:if test="${empty row.bean.uncompletedCRFs && empty row.bean.displayEventCRFs}">
                                                <div class="clinexia-form-row clinexia-form-row-empty">
                                                    <div class="clinexia-form-row-copy">
                                                        <span class="clinexia-form-name">No forms assigned</span>
                                                        <span class="clinexia-form-state">
                                                            <c:choose>
                                                                <c:when test="${canConfigureVisitForms && not empty visitConfigUrl}">This visit is ready, but it still needs forms assigned in configuration.</c:when>
                                                                <c:otherwise>This visit is available but has no forms to open yet.</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <c:if test="${canConfigureVisitForms && not empty visitConfigUrl}">
                                                        <a class="clinexia-table-action" href="<c:out value='${visitConfigUrl}'/>">Open Configuration</a>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="clinexia-patient-empty">
                            <div class="clinexia-patient-empty-title">No visits yet</div>
                            <p class="clinexia-patient-empty-copy">Start a visit to open the patient workflow and begin data collection right away.</p>
                            <div class="clinexia-empty-actions">
                                <a class="clinexia-table-action clinexia-primary-action" href="CreateNewStudyEvent?studySubjectId=<c:out value='${studySub.id}'/>&amp;autostart=baseline">Start Visit</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>

        <aside class="clinexia-patient-sidebar">
            <section class="clinexia-patient-card">
                <div class="clinexia-patient-card-header">
                    <div>
                        <span class="clinexia-section-kicker">Patient Details</span>
                        <h2>Status snapshot</h2>
                    </div>
                </div>
                <dl class="clinexia-patient-facts">
                    <div>
                        <dt>Patient ID</dt>
                        <dd><c:out value="${studySub.label}"/></dd>
                    </div>
                    <div>
                        <dt>Status</dt>
                        <dd><c:out value="${studySub.status.name}"/></dd>
                    </div>
                    <div>
                        <dt>Study</dt>
                        <dd><c:out value="${associatedStudyName}"/></dd>
                    </div>
                    <div>
                        <dt>Site</dt>
                        <dd><c:out value="${subjectStudy.name}"/></dd>
                    </div>
                    <div>
                        <dt>Enrollment Date</dt>
                        <dd><fmt:formatDate value="${studySub.enrollmentDate}" pattern="${dteFormat}"/></dd>
                    </div>
                    <c:if test="${not empty subject.uniqueIdentifier}">
                        <div>
                            <dt>Patient ID Reference</dt>
                            <dd><c:out value="${subject.uniqueIdentifier}"/></dd>
                        </div>
                    </c:if>
                    <c:if test="${not empty studySub.secondaryLabel}">
                        <div>
                            <dt>Secondary Reference</dt>
                            <dd><c:out value="${studySub.secondaryLabel}"/></dd>
                        </div>
                    </c:if>
                </dl>
            </section>
        </aside>
    </div>
</div>

<%-- <p>
    <a href="#events"><fmt:message key="events" bundle="${resword}"/></a> &nbsp; &nbsp; &nbsp;
    <a href="#group"><fmt:message key="group" bundle="${resword}"/></a> &nbsp;&nbsp;&nbsp;
    <a href="#global"><fmt:message key="global_subject_record" bundle="${resword}"/></a> &nbsp;&nbsp;&nbsp;
    <a href="javascript:openDocWindow('ViewStudySubjectAuditLog?id=<c:out value="${studySub.id}"/>')"><fmt:message key="audit_logs" bundle="${resword}"/></a>
</p> --%>

<div class="clinexia-legacy-detail-sections" hidden>
<c:choose>
    <c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
        <div class="table_title_Admin">
    </c:when>
    <c:otherwise>

        <c:choose>
            <c:when test="${userRole.manageStudy}">
                <div class="table_titla_manage">
            </c:when>
            <c:otherwise>
                <div class="table_title_submit">
            </c:otherwise>
        </c:choose>

    </c:otherwise>
</c:choose>

<a href="javascript:leftnavExpand('studySubjectRecord');">
	<img id="excl_studySubjectRecord" src="images/bt_Expand.gif" border="0"> Patient Record</a></div>
<div id="studySubjectRecord" style="display: none">

<table border="0" cellpadding="0" cellspacing="0">
		<tbody><tr>

			<td style="padding-right: 20px;" valign="top" width="800">



	<!-- These DIVs define shaded box borders -->

		<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

			<div class="tablebox_center">

			<table width="800" border="0" cellpadding="0" cellspacing="0">

		<!-- Table Actions row (pagination, search, tools) -->

				<tbody><tr>

			<!-- Table Tools/Actions cell -->

					<td class="table_actions" valign="top" align="right">
					<table border="0" cellpadding="0" cellspacing="0">
						<tbody><tr>
							<td class="table_tools">
							<a href="javascript:openDocWindow('ViewStudySubjectAuditLog?id=<c:out value="${studySub.id}"/>')"><fmt:message key="audit_logs" bundle="${resword}"/></a>
                            <c:if test="${study.status.available}">
                                 <c:if test="${!userRole.monitor}">
                                    |
	        		    		    <a href="UpdateStudySubject?id=<c:out value="${studySub.id}"/>&amp;action=show"><fmt:message key="edit_record" bundle="${resword}"/></a>
                                 </c:if>
                           </c:if>
						   </td>
						</tr>
					</tbody></table>
					</td>

			<!-- End Table Tools/Actions cell -->
				</tr>

		<!-- end Table Actions row (pagination, search, tools) -->

				<tr>
					<td valign="top">

			<!-- Table Contents -->

					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tbody><tr>
							<td class="table_header_column_top">Patient ID</td>
							<td class="table_cell_top"><c:out value="${studySub.label}"/></td>
							<td class="table_header_row"><fmt:message key="person_ID" bundle="${resword}"/>

							<%-- DN for person ID goes here --%>
							<c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
					            <c:set var="isNew" value="${hasUniqueIDNote eq 'yes' ? 0 : 1}"/>

					            <c:choose>
					                <c:when test="${hasUniqueIDNote eq 'yes'}">
					                    <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=uniqueIdentifier&column=unique_identifier','spanAlert-uniqueIdentifier'); return false;">
											<c:choose>
												<c:when test="${statusDnUniquId eq 2}"> <!-- Update -->
													<img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnUniquId eq 3}"> <!-- Resolution Proposed -->
													<img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnUniquId eq 4}"> <!-- Closed -->
													<img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnUniquId eq 5}"> <!-- Not Applicable -->
													<img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:otherwise> <!-- New -->
													<img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
												</c:otherwise>
											</c:choose> 	
					                    </a>

					                </c:when>
					                <c:otherwise>

					                            <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=uniqueIdentifier&column=unique_identifier','spanAlert-uniqueIdentifier'); return false;">
					                                <img id="flag_uniqueIdentifier" name="flag_uniqueIdentifier" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
					                            </a>
					                </c:otherwise>
					            </c:choose>
					        </c:if>
							</td>
    						<td class="table_cell_top"><c:out value="${subject.uniqueIdentifier}"/>
					      	</td>
						</tr>

						<tr>
							<td class="table_header_column"><fmt:message key="secondary_ID" bundle="${resword}"/></td>
							<td class="table_cell"><c:out value="${studySub.secondaryLabel}"/></td>
							<c:choose>
							    <c:when test="${subjectStudy.studyParameterConfig.collectDob == '1'}">

							            <td class="table_header_row"><fmt:message key="date_of_birth" bundle="${resword}"/>

							            <%-- DN for DOB goes here --%>
							            <c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
						                    <c:set var="isNew" value="${hasDOBNote eq 'yes' ? 0 : 1}"/>

						                    <c:choose>
						                        <c:when test="${hasDOBNote eq 'yes'}">
						                            <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth','spanAlert-dob'); return false;">
														<c:choose>
															<c:when test="${statusDnDob eq 2}"> <!-- Update -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 3}"> <!-- Resolution Proposed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 4}"> <!-- Closed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 5}"> <!-- Not Applicable -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:otherwise> <!-- New -->
																<img id="flag_dob" name="flag_dob" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
															</c:otherwise>
														</c:choose> 	
						                            </a>

						                        </c:when>
						                        <c:otherwise>

						                                <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth&new=1','spanAlert-dob'); return false;">
						                                    <img id="flag_dob" name="flag_dob" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
						                                </a>
						                        </c:otherwise>
						                    </c:choose>

						                </c:if>
							            </td>
							            <td class="table_cell"><fmt:formatDate value="${subject.dateOfBirth}" pattern="${dteFormat}"/></td>

							    </c:when>
							    <c:when test="${subjectStudy.studyParameterConfig.collectDob == '3'}">

							            <td class="table_header_row"><fmt:message key="date_of_birth" bundle="${resword}"/>

							            <%-- DN for DOB goes here --%>
							            <c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
						                    <c:set var="isNew" value="${hasDOBNote eq 'yes' ? 0 : 1}"/>

						                    <c:choose>
						                        <c:when test="${hasDOBNote eq 'yes'}">
						                            <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth','spanAlert-dob'); return false;">
														<c:choose>
															<c:when test="${statusDnDob eq 2}"> <!-- Update -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 3}"> <!-- Resolution Proposed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 4}"> <!-- Closed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 5}"> <!-- Not Applicable -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:otherwise> <!-- New -->
																<img id="flag_dob" name="flag_dob" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
															</c:otherwise>
														</c:choose> 	
						                            </a>

						                        </c:when>
						                        <c:otherwise>

						                                <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth&new=1','spanAlert-dob'); return false;">
						                                    <img id="flag_dob" name="flag_dob" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
						                                </a>
						                        </c:otherwise>
						                    </c:choose>

						                </c:if>
							            </td>
							            <td class="table_cell"><fmt:message key="not_used" bundle="${resword}"/></td>

							    </c:when>
							    <c:otherwise>

							            <td class="table_header_row"><fmt:message key="year_of_birth" bundle="${resword}"/>

							            <%-- DN for DOB goes here --%>
							            <c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
						                    <c:set var="isNew" value="${hasDOBNote eq 'yes' ? 0 : 1}"/>

						                    <c:choose>
						                        <c:when test="${hasDOBNote eq 'yes'}">
						                            <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth','spanAlert-dob'); return false;">
														<c:choose>
															<c:when test="${statusDnDob eq 2}"> <!-- Update -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 3}"> <!-- Resolution Proposed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 4}"> <!-- Closed -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:when test="${statusDnDob eq 5}"> <!-- Not Applicable -->
																<img id="flag_dob" name="flag_dob" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
															</c:when>
															<c:otherwise> <!-- New -->
																<img id="flag_dob" name="flag_dob" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
															</c:otherwise>
														</c:choose> 	
						                            </a>

						                        </c:when>
						                        <c:otherwise>

						                                <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=dob&column=date_of_birth&new=1','spanAlert-dob'); return false;">
						                                    <img id="flag_dob" name="flag_dob" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
						                                </a>
						                        </c:otherwise>
						                    </c:choose>

						                </c:if>
							            </td>
							            <td class="table_cell"><c:out value="${yearOfBirth}"/>
							            </td>

							    </c:otherwise>
							</c:choose>

						</tr>
                        <tr>

							<td class="table_header_column"><fmt:message key="OID" bundle="${resword}"/></td>
    						<td class="table_cell"><c:out value="${studySub.oid}"/></td>
							<td class="table_header_row"><fmt:message key="gender" bundle="${resword}"/>

							<%-- DN for Gender goes here --%>
							<c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
					            <c:set var="isNew" value="${hasGenderNote eq 'yes' ? 0 : 1}"/>
					            <c:choose>
					                <c:when test="${hasGenderNote eq 'yes'}">
					                    <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${subject.id}&name=subject&field=gender&column=gender','spanAlert-gender'); return false;">
											<c:choose>
												<c:when test="${statusDnGender eq 2}"> <!-- Update -->
													<img id="flag_gender" name="flag_gender" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnGender eq 3}"> <!-- Resolution Proposed -->
													<img id="flag_gender" name="flag_gender" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnGender eq 4}"> <!-- Closed -->
													<img id="flag_gender" name="flag_gender" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:when test="${statusDnGender eq 5}"> <!-- Not Applicable -->
													<img id="flag_gender" name="flag_gender" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
												</c:when>
												<c:otherwise> <!-- New -->
													<img id="flag_gender" name="flag_gender" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
												</c:otherwise>
											</c:choose> 	
					                    </a>
					                </c:when>
					                <c:otherwise>
					                    <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?subjectId=${studySub.id}&id=${subject.id}&writeToDB=1&name=subject&field=gender&column=gender','spanAlert-gender'); return false;">
					                        <img id="flag_gender" name="flag_gender" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
					                    </a>
					                </c:otherwise>
					            </c:choose>
					        </c:if>
							</td>
						    <td class="table_cell">

						        <c:choose>
						            <c:when test="${subject.gender==32}">
						                &nbsp;
						            </c:when>
						            <c:when test="${subject.gender==109 ||subject.gender==77}">
						                <fmt:message key="male" bundle="${resword}"/>
						            </c:when>
						            <c:otherwise>
						                <fmt:message key="female" bundle="${resword}"/>
						            </c:otherwise>
						        </c:choose>

							</td>
						</tr>
						<tr>
							<td class="table_header_column"><fmt:message key="status" bundle="${resword}"/></td>
                    		<td class="table_cell"><c:out value="${studySub.status.name}"/></td>
							<td class="table_header_row"><fmt:message key="enrollment_date" bundle="${resword}"/>
							&nbsp;
							<%-- DN for enrollment date goes here --%>
							<c:if test="${subjectStudy.studyParameterConfig.discrepancyManagement=='true' && !study.status.locked}">
					            <c:set var="isNew" value="${hasEnrollmentNote eq 'yes' ? 0 : 1}"/>
							        <c:choose>
							            <c:when test="${hasEnrollmentNote eq 'yes'}">
							                <a href="#" onClick="openDNoteWindow('ViewDiscrepancyNote?writeToDB=1&subjectId=${studySub.id}&id=${studySub.id}&name=studySub&field=enrollmentDate&column=enrollment_date','spanAlert-enrollmentDate'); return false;">
												<c:choose>
													<c:when test="${statusDnEnrollment eq 2}"> <!-- Update -->
														<img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_flagYellow.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
													</c:when>
													<c:when test="${statusDnEnrollment eq 3}"> <!-- Resolution Proposed -->
														<img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_flagGreen.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
													</c:when>
													<c:when test="${statusDnEnrollment eq 4}"> <!-- Closed -->
														<img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_flagBlack.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
													</c:when>
													<c:when test="${statusDnEnrollment eq 5}"> <!-- Not Applicable -->
														<img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_flagWhite.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>">
													</c:when>
													<c:otherwise> <!-- New -->
														<img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_Note.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
													</c:otherwise>
												</c:choose> 	
							                </a>
							            </c:when>
							            <c:otherwise>
							                <a href="#" onClick="openDNoteWindow('CreateDiscrepancyNote?subjectId=${studySub.id}&id=${studySub.id}&writeToDB=1&name=studySub&field=enrollmentDate&column=enrollment_date','spanAlert-enrollmentDate'); return false;">
							                    <img id="flag_enrollmentDate" name="flag_enrollmentDate" src="images/icon_noNote.gif" border="0" alt="<fmt:message key="discrepancy_note" bundle="${resword}"/>" title="<fmt:message key="discrepancy_note" bundle="${resword}"/>" >
							                </a>
							            </c:otherwise>
							        </c:choose>
					            </c:if>
							</td>
    						<td class="table_cell"><fmt:formatDate value="${studySub.enrollmentDate}" pattern="${dteFormat}"/>&nbsp;
					     	</td>
						</tr>
                        <tr>
							<td class="table_divider" colspan="4">&nbsp;</td>
						</tr>

               			<tr>

		                    <td class="table_header_column_top"><fmt:message key="study_name" bundle="${resword}"/></td>
		                    <td class="table_cell_top">
		                        <c:choose>
		                            <c:when test="${subjectStudy.parentStudyId>0}">
		                                <a href="ViewStudy?id=<c:out value="${parentStudy.id}"/>&amp;viewFull=yes"><c:out value="${parentStudy.name}"/></a>
		                            </c:when>
		                            <c:otherwise>
		                                <a href="ViewStudy?id=<c:out value="${subjectStudy.id}"/>&amp;viewFull=yes"><c:out value="${subjectStudy.name}"/></a>
		                            </c:otherwise>
		                        </c:choose>
		                    </td>
							<td class="table_header_row"><fmt:message key="site_name" bundle="${resword}"/></td>
		                    <td class="table_cell_top">
		                        <c:if test="${subjectStudy.parentStudyId>0}">
		                            <a href="ViewStudy?id=<c:out value="${subjectStudy.id}"/>"><c:out value="${subjectStudy.name}"/></a>
		                        </c:if>&nbsp;</td>
						</tr>

					</tbody></table>

			<!-- End Table Contents -->

					</td>
				</tr>
			</tbody></table>


			</div>

		</div></div></div></div></div></div></div></div>

			</td>
		</tr>
	</tbody></table>
	<br>


</div>
<%--
</div></div></div></div></div></div></div></div>

</td>


<td valign="top" width="350" style="padding-right: 20px">

    <div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

        <div class="tablebox_center">
            <table border="0" cellpadding="0" cellspacing="0" width="330">
                <tr>
                    <td colspan="2" align="right" valign="top" class="table_actions">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="table_header_column_top"><fmt:message key="study_name" bundle="${resword}"/></td>
                    <td class="table_cell_top">
                        <c:choose>
                            <c:when test="${subjectStudy.parentStudyId>0}">
                                <c:out value="${parentStudy.name}"/>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${subjectStudy.name}"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="unique_protocol_ID" bundle="${resword}"/></td>
                    <td class="table_cell"><c:out value="${subjectStudy.identifier}"/></td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="site_name" bundle="${resword}"/></td>
                    <td class="table_cell">
                        <c:if test="${subjectStudy.parentStudyId>0}">
                            <c:out value="${subjectStudy.name}"/>
                        </c:if>&nbsp;</td>
                </tr>


                <tr>
                    <td class="table_divider" colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="table_header_column_top"><fmt:message key="date_record_created" bundle="${resword}"/></td>
                    <td class="table_cell_top"><fmt:formatDate value="${studySub.createdDate}" pattern="${dteFormat}"/></td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="created_by" bundle="${resword}"/></td>
                    <td class="table_cell"><c:out value="${studySub.owner.name}"/></td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="date_record_last_updated" bundle="${resword}"/></td>
                    <td class="table_cell"><fmt:formatDate value="${studySub.updatedDate}" pattern="${dteFormat}"/>&nbsp;</td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="updated_by" bundle="${resword}"/></td>
                    <td class="table_cell"><c:out value="${studySub.updater.name}"/>&nbsp;</td>
                </tr>
                <tr>
                    <td class="table_header_column"><fmt:message key="status" bundle="${resword}"/></td>
                    <td class="table_cell"><c:out value="${studySub.status.name}"/></td>
                </tr>
            </table>
        </div>

    </div></div></div></div></div></div></div></div>

</td>
</tr>
</table>
<br><br>
</div>
--%>

<c:choose>
    <c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
        <div class="table_title_Admin">
    </c:when>
    <c:otherwise>

        <c:choose>
            <c:when test="${userRole.manageStudy}">
                <div class="table_titla_manage">
            </c:when>
            <c:otherwise>
                <div class="table_title_submit">
            </c:otherwise>
        </c:choose>

    </c:otherwise>
</c:choose>
<a name="events"><a href="javascript:leftnavExpand('subjectEvents');">
    <img id="excl_subjectEvents" src="images/bt_Expand.gif" border="0"> Detailed visit matrix</a></a></div>
<div id="subjectEvents" style="display:none;">
    <c:import url="../include/showTable.jsp"><c:param name="rowURL" value="showStudyEventRow.jsp" /></c:import>


    </br></br>
</div>

<div style="width: 250px">

<c:choose>
<c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
<div class="table_title_Admin">
</c:when>
<c:otherwise>

<c:choose>
<c:when test="${userRole.manageStudy}">
<div class="table_titla_manage">
</c:when>
<c:otherwise>
<div class="table_title_submit">
    </c:otherwise>
    </c:choose>

    </c:otherwise>
    </c:choose>
        <a name="group"><a href="javascript:leftnavExpand('groups');">
            <img id="excl_groups" src="images/bt_Expand.gif" border="0"> Assignments</a></a></div>
<div id="groups" style="display:none;">
    <div style="width: 600px">
        <!-- These DIVs define shaded box borders -->
        <div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

            <div class="tablebox_center">

                <table border="0" cellpadding="0" cellspacing="0" width="100%">

                    <!-- Table Actions row (pagination, search, tools) -->

                    <tr>

                        <!-- Table Tools/Actions cell -->

                        <td align="right" valign="top" class="table_actions">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="table_tools">
                                        <c:if test="${study.status.available && !(empty groups)}">
                                            <a href="UpdateStudySubject?id=<c:out value="${studySub.id}"/>&action=show"><fmt:message key="assign_subject_to_group" bundle="${resworkflow}"/></a>
                                        </c:if>
                                    </td>
                                </tr>
                            </table>
                        </td>

                        <!-- End Table Tools/Actions cell -->
                    </tr>

                    <!-- end Table Actions row (pagination, search, tools) -->

                    <tr>
                        <td valign="top">

                            <!-- Table Contents -->

                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="table_header_row_left"><fmt:message key="subject_group_class" bundle="${resword}"/></td>
                                    <td class="table_header_row"><fmt:message key="study_group" bundle="${resword}"/></td>
                                    <td class="table_header_row"><fmt:message key="notes" bundle="${resword}"/></td>
                                </tr>
                                <c:choose>
                                    <c:when test="${!empty groups}">
                                        <c:forEach var="group" items="${groups}">
                                            <tr>
                                                <td class="table_cell_left"><c:out value="${group.groupClassName}"/></td>
                                                <td class="table_cell"><c:out value="${group.studyGroupName}"/></td>
                                                <td class="table_cell"><c:out value="${group.notes}"/>&nbsp;</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="table_cell" colspan="2"><fmt:message key="currently_no_groups" bundle="${resword}"/></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </table>

                            <!-- End Table Contents -->

                        </td>
                    </tr>
                </table>


            </div>

        </div></div></div></div></div></div></div></div>

    </div>

    <br><br>
</div>

<div style="width: 250px">

<c:choose>
<c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
<div class="table_title_Admin">
</c:when>
<c:otherwise>

<c:choose>
<c:when test="${userRole.manageStudy}">
<div class="table_titla_manage">
</c:when>
<c:otherwise>
<div class="table_title_submit">
    </c:otherwise>
    </c:choose>

    </c:otherwise>
    </c:choose>
</div>
<c:choose>
<c:when test="${isAdminServlet == 'admin' && userBean.sysAdmin && module=='admin'}">
<div class="table_title_Admin">
</c:when>
<c:otherwise>

<c:choose>
<c:when test="${userRole.manageStudy}">
<div class="table_titla_manage">
</c:when>
<c:otherwise>
<div class="table_title_submit">
    </c:otherwise>
    </c:choose>

    </c:otherwise>
    </c:choose>	<a name="global"><a href="javascript:leftnavExpand('globalRecord');">
        <img id="excl_globalRecord" src="images/bt_Expand.gif" border="0"> Patient profile</a></a></div>

<div id="globalRecord" style="display:none">
<div style="width: 350px">
<!-- These DIVs define shaded box borders -->
<div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

<div class="tablebox_center">

<table border="0" cellpadding="0" cellspacing="0" width="330">

<!-- Table Actions row (pagination, search, tools) -->

<tr>

    <!-- Table Tools/Actions cell -->

    <td align="right" valign="top" class="table_actions">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td class="table_tools">
                    <c:if test="${userBean.sysAdmin}">
                        <c:if test="${study.status.available}">
                            <a href="UpdateSubject?id=<c:out value="${subject.id}"/>&studySubId=<c:out value="${studySub.id}"/>&action=show"><fmt:message key="edit_record" bundle="${resword}"/></a>
                        </c:if>
                    </c:if>
                </td>
            </tr>
        </table>
    </td>

    <!-- End Table Tools/Actions cell -->
</tr>

<!-- end Table Actions row (pagination, search, tools) -->

<tr>
    <td valign="top">

        <!-- Table Contents -->

        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="table_header_column_top"><fmt:message key="person_ID" bundle="${resword}"/></td>
                <td class="table_cell_top"><c:out value="${subject.uniqueIdentifier}"/></td>
            </tr>
            <tr>
                <td class="table_divider" colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="table_header_column_top"><fmt:message key="date_record_created" bundle="${resword}"/></td>
                <td class="table_cell_top"><fmt:formatDate value="${subject.createdDate}" pattern="${dteFormat}"/></td>
            </tr>
            <tr>
                <td class="table_header_column"><fmt:message key="created_by" bundle="${resword}"/></td>
                <td class="table_cell"><c:out value="${subject.owner.name}"/></td>
            </tr>
            <tr>
                <td class="table_header_column"><fmt:message key="date_record_last_updated" bundle="${resword}"/></td>
                <td class="table_cell"><fmt:formatDate value="${subject.updatedDate}" pattern="${dteFormat}"/>&nbsp;</td>
            </tr>
            <tr>
                <td class="table_header_column"><fmt:message key="updated_by" bundle="${resword}"/></td>
                <td class="table_cell"><c:out value="${subject.updater.name}"/>&nbsp;</td>
            </tr>
            <tr>
                <td class="table_header_column"><fmt:message key="status" bundle="${resword}"/></td>
                <td class="table_cell"><c:out value="${subject.status.name}"/></td>
            </tr>
            <tr>
                <td class="table_divider" colspan="2">&nbsp;</td>
            </tr>
            <c:choose>
                <c:when test="${subjectStudy.studyParameterConfig.collectDob == '1'}">
                    <tr>
                        <td class="table_header_column_top"><fmt:message key="date_of_birth" bundle="${resword}"/></td>
                        <td class="table_cell_top"><fmt:formatDate value="${subject.dateOfBirth}" pattern="${dteFormat}"/></td>
                    </tr>
                </c:when>
                <c:when test="${subjectStudy.studyParameterConfig.collectDob == '3'}">
                    <tr>
                        <td class="table_header_column_top"><fmt:message key="date_of_birth" bundle="${resword}"/></td>
                        <td class="table_cell_top">&nbsp;</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td class="table_header_column_top"><fmt:message key="year_of_birth" bundle="${resword}"/></td>
                        <td class="table_cell_top"><c:out value="${yearOfBirth}"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
            <tr>
                <td class="table_header_column"><fmt:message key="gender" bundle="${resword}"/></td>
                <td class="table_cell">
                    <c:choose>
                        <c:when test="${subject.gender==32}">
                            &nbsp;
                        </c:when>
                        <c:when test="${subject.gender==109 ||subject.gender==77}">
                            <fmt:message key="male" bundle="${resword}"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="female" bundle="${resword}"/>
                        </c:otherwise>
                    </c:choose>

                </td>
            </tr>
        </table>

        <!-- End Table Contents -->

    </td>
</tr>
</table>


</div>

</div></div></div></div></div></div></div></div>
</div>

</div>
</div>

<jsp:include page="studySubject/casebookGenerationForm.jsp"/>

<c:choose>
<c:when test="${from =='listSubject' && userBean.sysAdmin && module=='admin'}">
<p> <a href="ViewSubject?id=<c:out value="${subject.id}"/>"><fmt:message key="go_back_to_view_subject" bundle="${resword}"/></a>  </p>
</c:when>
<c:otherwise>

<c:choose>
<c:when test="${(userRole.manageStudy)&& module=='manage'}">
<p> <a href="ListStudySubject"><fmt:message key="go_back_to_study_subject_list" bundle="${resword}"/></a>  </p>
</c:when>
<c:otherwise>
<p><a href="ListStudySubjects"><fmt:message key="go_back_to_subject_list" bundle="${resword}"/></a>  </p>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
<!-- End Main Content Area -->



<jsp:include page="../include/footer.jsp"/>

<script type="text/javascript" src="includes/studySubject/viewStudySubject.js"></script>
