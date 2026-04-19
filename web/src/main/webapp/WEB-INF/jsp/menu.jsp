<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.page_messages" var="resmessages"/>

<jsp:useBean scope='session' id='userBean' class='org.akaza.openclinica.bean.login.UserAccountBean'/>
<jsp:useBean scope='session' id='study' class='org.akaza.openclinica.bean.managestudy.StudyBean' />
<jsp:useBean scope='session' id='userRole' class='org.akaza.openclinica.bean.login.StudyUserRoleBean' />

<!-- start of menu.jsp -->

<jsp:include page="include/home-header.jsp"/>

<jsp:include page="include/sideAlert.jsp"/>

<script type="text/JavaScript" src="includes/jmesa/jquery.jmesa.js"></script>
<script type="text/JavaScript" src="includes/jmesa/jmesa.js"></script>
<script type="text/javascript" src="includes/jmesa/jquery.blockUI.js"></script>

<link rel="stylesheet" href="includes/jmesa/jmesa.css" type="text/css">

<!-- warning is study is frozen or locked -->
<div id="box" class="dialog">
	<span id="mbm">
	    <br><fmt:message key="study_frozen_locked_note" bundle="${restext}"/>
	</span>
	<br>
    <div>
        <button onclick="hm('box');">OK</button>
    </div>
</div>

<!-- then instructions-->
	<tr id="sidebar_Instructions_open" style="display: all">
        <td class="sidebar_tab">
	        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');">
    	    <img src="images/sidebar_collapse.gif" class="sidebar_collapse_expand"></a>
			<b><fmt:message key="instructions" bundle="${resword}"/></b>
			<div class="sidebar_tab_content"><fmt:message key="may_change_request_access" bundle="${restext}"/></div>
        </td>
	</tr>
    <tr id="sidebar_Instructions_closed" style="display: none">
        <td class="sidebar_tab">
	        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');">
	        <img src="images/sidebar_expand.gif" class="sidebar_collapse_expand"></a>
	        <b><fmt:message key="instructions" bundle="${resword}"/></b>
        </td>
	</tr>

<jsp:include page="include/sideInfo.jsp"/>

<c:set var="roleName" value=""/>
<c:if test="${userRole != null && !userRole.invalid}">
	<c:set var="roleName" value="${userRole.role.name}"/>
	<c:set var="studyidentifier">
   		<span class="alert"><c:out value="${study.identifier}"/></span>
	</c:set>
</c:if>

<div class="clinexia-dashboard-page">
    <section class="card clinexia-dashboard-hero">
        <div>
            <span class="clinexia-page-eyebrow">Clinexia Dashboard</span>
            <h1 class="clinexia-page-title">Estudio Actual</h1>
            <p class="clinexia-page-subtitle">
                <c:choose>
                    <c:when test='${study.parentStudyId > 0}'>
                        <c:out value='${study.parentStudyName}'/>
                    </c:when>
                    <c:otherwise>
                        <c:out value='${study.name}'/>
                    </c:otherwise>
                </c:choose>
                <span class="clinexia-page-separator">-</span>
                <c:out value="${study.identifier}"/>
            </p>
        </div>
        <div class="clinexia-study-chip">
            <span class="clinexia-study-chip-label">Rol activo</span>
            <strong><c:out value="${userRole.role.description}" /></strong>
        </div>
    </section>

    <section class="clinexia-dashboard-grid clinexia-metrics-grid">
        <article class="card clinexia-metric-card">
            <span class="clinexia-metric-label">Pacientes Enrolados</span>
            <strong class="clinexia-metric-value" id="metricEnrolled">--</strong>
            <span class="clinexia-metric-subtitle" id="metricEnrolledSub">Sincronizado desde el resumen del estudio</span>
        </article>

        <article class="card clinexia-metric-card clinexia-progress-card">
            <div>
                <span class="clinexia-metric-label">Progreso del Estudio</span>
                <strong class="clinexia-metric-value" id="metricProgress">--</strong>
                <span class="clinexia-metric-subtitle">Estado operativo general</span>
            </div>
            <div class="clinexia-progress-ring" id="metricProgressRing">
                <span>CSS</span>
            </div>
        </article>

        <article class="card clinexia-metric-card clinexia-alert-card ${assignedDiscrepancies > 5 ? 'is-high' : assignedDiscrepancies > 0 ? 'is-medium' : 'is-low'}">
            <span class="clinexia-metric-label">Alertas</span>
            <strong class="clinexia-metric-value" id="metricAlerts" data-count="${assignedDiscrepancies}">${assignedDiscrepancies}</strong>
            <a class="clinexia-metric-subtitle" href="ViewNotes?module=submit&listNotes_f_discrepancyNoteBean.user=<c:out value='${userBean.name}' />">
                Ver notas asignadas y discrepancias
            </a>
        </article>
    </section>

    <section class="clinexia-dashboard-grid clinexia-panel-grid">
        <c:if test="${userRole.investigator || userRole.researchAssistant || userRole.researchAssistant2}">
            <div class="card clinexia-panel-card clinexia-panel-wide" id="findSubjectsPanel">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Study Subjects</h2>
                        <p>Busqueda operativa y acceso rapido a sujetos del estudio.</p>
                    </div>
                </div>
                <div id="findSubjectsDiv">
                    <script type="text/javascript">
                    function onInvokeAction(id,action) {
                        if(id.indexOf('findSubjects') == -1)  {
                        setExportToLimit(id, '');
                        }
                        createHiddenInputFieldsForLimitAndSubmit(id);
                    }
                    function onInvokeExportAction(id) {
                        var parameterString = createParameterStringForLimit(id);
                        location.href = '${pageContext.request.contextPath}/MainMenu?'+ parameterString;
                    }
                    jQuery(document).ready(function() {
                        jQuery('#addSubject').click(function() {
                            jQuery.blockUI({ message: jQuery('#addSubjectForm'), css:{left: "300px", top:"10px" } });
                        });

                        jQuery('#cancel').click(function() {
                            jQuery.unblockUI();
                            return false;
                        });
                    });
                    </script>
                    <form action="${pageContext.request.contextPath}/ListStudySubjects">
                        <input type="hidden" name="module" value="admin">
                        ${findSubjectsHtml}
                    </form>
                </div>
                <div id="addSubjectForm" style="display:none;">
                    <c:import url="addSubjectMonitor.jsp"/>
                </div>
            </div>
        </c:if>

        <c:if test="${userRole.coordinator || userRole.director}">
            <script type="text/javascript">
                function onInvokeAction(id,action) {
                    if(id.indexOf('studySiteStatistics') == -1)  {
                        setExportToLimit(id, '');
                    }
                    if(id.indexOf('subjectEventStatusStatistics') == -1)  {
                        setExportToLimit(id, '');
                    }
                    if(id.indexOf('studySubjectStatusStatistics') == -1)  {
                        setExportToLimit(id, '');
                    }
                    createHiddenInputFieldsForLimitAndSubmit(id);
                }
            </script>

            <div class="card clinexia-panel-card" id="studySiteStatisticsPanel">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Sites</h2>
                        <p>Distribucion operativa y cobertura del estudio.</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/MainMenu">
                    ${studySiteStatistics}
                </form>
            </div>

            <div class="card clinexia-panel-card" id="studyStatisticsPanel">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Progreso</h2>
                        <p>Resumen visual del estado general del estudio.</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/MainMenu">
                    ${studyStatistics}
                </form>
            </div>

            <div class="card clinexia-panel-card" id="subjectEventStatusPanel">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Eventos</h2>
                        <p>Estado de eventos y seguimiento clinico.</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/MainMenu">
                    ${subjectEventStatusStatistics}
                </form>
            </div>

            <div class="card clinexia-panel-card" id="studySubjectStatusPanel">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Pacientes</h2>
                        <p>Actividad de sujetos y progreso de enrolamiento.</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/MainMenu">
                    ${studySubjectStatusStatistics}
                </form>
            </div>
        </c:if>

        <c:if test="${userRole.monitor}">
            <script type="text/javascript">
                function onInvokeAction(id,action) {
                    setExportToLimit(id, '');
                    createHiddenInputFieldsForLimitAndSubmit(id);
                }
                function onInvokeExportAction(id) {
                    var parameterString = createParameterStringForLimit(id);
                }
                function prompt(formObj,crfId){
                    var bool = confirm(
                            "<fmt:message key="uncheck_sdv" bundle="${resmessages}"/>");
                    if(bool){
                        formObj.action='${pageContext.request.contextPath}/pages/handleSDVRemove';
                        formObj.crfId.value=crfId;
                        formObj.submit();
                    }
                }
            </script>

            <div class="card clinexia-panel-card clinexia-panel-wide">
                <div class="clinexia-panel-head">
                    <div>
                        <h2>Tasks</h2>
                        <p>Seguimiento SDV y acciones pendientes del monitor.</p>
                    </div>
                </div>
                <div id="searchFilterSDV">
                    <table>
                        <tr>
                            <td valign="bottom" id="Tab1'">
                                <div id="Tab1NotSelected"><div class="tab_BG"><div class="tab_L"><div class="tab_R">
                                    <a class="tabtext" title="<fmt:message key="view_by_event_CRF" bundle="${resword}"/>" href='pages/viewAllSubjectSDVtmp?studyId=${studyId}' onclick="javascript:HighlightTab(1);"><fmt:message key="view_by_event_CRF" bundle="${resword}"/></a></div></div></div></div>
                               <div id="Tab1Selected" style="display:none"><div class="tab_BG_h"><div class="tab_L_h"><div class="tab_R_h"><span class="tabtext"><fmt:message key="view_by_event_CRF" bundle="${resword}"/></span></div></div></div></div></td>

                           <td valign="bottom" id="Tab2'">
                               <div id="Tab2Selected"><div class="tab_BG"><div class="tab_L"><div class="tab_R">
                               <a class="tabtext" title="<fmt:message key="view_by_studysubjectID" bundle="${resword}"/>" href='pages/viewSubjectAggregate?studyId=${studyId}' onclick="javascript:HighlightTab(2);"><fmt:message key="view_by_studysubjectID" bundle="${resword}"/></a></div></div></div></div>
                               <div id="Tab2NotSelected" style="display:none"><div class="tab_BG_h"><div class="tab_L_h"><div class="tab_R_h"><span class="tabtext"><fmt:message key="view_by_studysubjectID" bundle="${resword}"/></span></div></div></div></div>
                           </td>
                       </tr>
                   </table>
                   <script type="text/javascript"> HighlightTab(1);</script>
                </div>
                <div id="subjectSDV">
                    <form name='sdvForm' action="${pageContext.request.contextPath}/pages/viewAllSubjectSDVtmp">
                        <input type="hidden" name="studyId" value="${study.id}">
                        <input type="hidden" name=imagePathPrefix value="">
                        <input type="hidden" name="crfId" value="0">
                        <input type="hidden" name="redirection" value="viewAllSubjectSDVtmp">
                        ${sdvMatrix}
                        <br />
                        <c:if test="${!(study.status.locked)}">
                             <input type="submit" name="sdvAllFormSubmit" class="button_medium" value="<fmt:message key="submit" bundle="${resword}"/>" onclick="this.form.method='POST';this.form.action='${pageContext.request.contextPath}/pages/handleSDVPost';this.form.submit();"/>
                             <input type="submit" name="sdvAllFormCancel" class="button_medium" value="<fmt:message key="cancel" bundle="${resword}"/>" onclick="this.form.action='${pageContext.request.contextPath}/pages/viewAllSubjectSDVtmp';this.form.submit();"/>
                       </c:if>
                    </form>
                </div>
            </div>
        </c:if>
    </section>

    <section class="card clinexia-task-card" id="clinexia-task-panel">
        <div class="clinexia-panel-head">
            <div>
                <h2>Quick Actions</h2>
                <p>Accesos rapidos para navegar el estudio sin perder la UI actual.</p>
            </div>
        </div>
        <div class="clinexia-quick-actions">
            <a href="${pageContext.request.contextPath}/MainMenu">Dashboard</a>
            <a href="${pageContext.request.contextPath}/ListStudySubjects">Study Subjects</a>
            <a href="${pageContext.request.contextPath}/ViewNotes?module=submit">Notes &amp; Discrepancies</a>
            <a href="${pageContext.request.contextPath}/StudyAuditLog">Study Audit Log</a>
            <a href="${pageContext.request.contextPath}/AdminSystem">Admin</a>
        </div>
    </section>
</div>

<script type="text/javascript">
    (function () {
        function getText(id) {
            var el = document.getElementById(id);
            return el ? (el.textContent || el.innerText || "") : "";
        }

        function extractFirstNumber(text) {
            var match = (text || "").replace(/\s+/g, " ").match(/\d+(?:[.,]\d+)?/);
            return match ? match[0].replace(",", ".") : null;
        }

        function extractPercent(text) {
            var match = (text || "").match(/(\d+(?:[.,]\d+)?)\s*%/);
            return match ? Math.round(parseFloat(match[1].replace(",", "."))) : null;
        }

        var metricEnrolled = document.getElementById("metricEnrolled");
        var metricEnrolledSub = document.getElementById("metricEnrolledSub");
        var metricProgress = document.getElementById("metricProgress");
        var metricProgressRing = document.getElementById("metricProgressRing");
        var metricAlerts = document.getElementById("metricAlerts");

        var enrolled = extractFirstNumber(getText("studySubjectStatusPanel")) ||
            extractFirstNumber(getText("findSubjectsPanel")) ||
            extractFirstNumber(getText("studyStatisticsPanel"));
        if (enrolled && metricEnrolled) {
            metricEnrolled.textContent = enrolled;
        }

        var siteCount = extractFirstNumber(getText("studySiteStatisticsPanel"));
        if (siteCount && metricEnrolledSub) {
            metricEnrolledSub.textContent = "+" + siteCount + " sitios activos";
        }

        var progress = extractPercent(getText("studyStatisticsPanel")) ||
            extractPercent(getText("subjectEventStatusPanel"));
        if (progress !== null && metricProgress && metricProgressRing) {
            metricProgress.textContent = progress + "%";
            metricProgressRing.style.setProperty("--progress", progress + "%");
            metricProgressRing.querySelector("span").textContent = progress + "%";
        }

        if (metricAlerts) {
            var alertCount = parseInt(metricAlerts.getAttribute("data-count"), 10) || 0;
            if (alertCount > 0) {
                metricAlerts.textContent = alertCount;
            }
        }
    })();
</script>

<!-- end of menu.jsp -->
<jsp:include page="include/footer.jsp"/>
