<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="org.akaza.openclinica.bean.core.DataEntryStage"%>
<%@ page import="org.akaza.openclinica.bean.core.SubjectEventStatus"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.terms" var="resterm"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<c:set var="dteFormat"><fmt:message key="date_format_string" bundle="${resformat}"/></c:set>

<c:set var="eblRowCount" value="${param.eblRowCount}" />
<!-- row number: <c:out value="${eblRowCount}"/> -->
<c:set var="eventCRFNum" value="${param.eventDefCRFNum}" />

<jsp:useBean scope="request" id="currRow" class="org.akaza.openclinica.web.bean.DisplayStudySubjectEventsRow" />
<c:set var="eventCount" value="0"/>
<c:forEach var="event" items="${currRow.bean.studyEvents}">
    <c:set var="eventCount" value="${eventCount+1}"/>
</c:forEach>
<c:set var="groups" value="3"/>
<c:forEach var="group" items="${currRow.bean.studyGroups}">
    <c:set var="groups" value="${groups+1}"/>
</c:forEach>

<c:choose>
<c:when test="${!empty currRow.bean.studyEvents}">
<c:set var="count" value="0"/>
<c:forEach var="event" items="${currRow.bean.studyEvents}">
<!-- an event is a DisplayStudyEventBean,which has -->
<!--StudyEventBean studyEvent; -->
<!--ArrayList allEventCRFs; -->
<!--StudySubjectBean studySubject;-->
<!--havingEventCRF = false;-->


<tr valign="top">

<c:if test="${count==0}">
    <td class="table_cell_left" rowspan="<c:out value="${eventCount}"/>">
        <c:out value="${currRow.bean.studySubject.label}"/>&nbsp;
    </td>
    <c:choose>
        <c:when test ="${currRow.sortingColumn >= 1 && currRow.sortingColumn < groups}">
            <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: all" id="Groups_0_1_<c:out value="${eblRowCount+1}"/>">
                <c:choose>
                    <c:when test="${currRow.bean.studySubject.status.id==1}">
                        <fmt:message key="active" bundle="${resword}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="inactive" bundle="${resword}"/>
                    </c:otherwise>
                </c:choose>
            </td>

            <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: all" id="Groups_0_2_<c:out value="${eblRowCount+1}"/>"><c:out value="${currRow.bean.studySubject.gender}"/>&nbsp;</td>

            <c:set var="groupCount" value="3"/>
            <c:forEach var="group" items="${currRow.bean.studyGroups}">
                <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: all" id="Groups_0_<c:out value="${groupCount}"/>_<c:out value="${eblRowCount+1}"/>"><c:out value="${group.studyGroupName}"/>&nbsp;</td>
                <c:set var="groupCount" value="${groupCount+1}"/>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: none" id="Groups_0_1_<c:out value="${eblRowCount+1}"/>">
                <c:choose>
                    <c:when test="${currRow.bean.studySubject.status.id==1}">
                        <fmt:message key="active" bundle="${resword}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="inactive" bundle="${resword}"/>
                    </c:otherwise>
                </c:choose>
            </td>

            <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: none" id="Groups_0_2_<c:out value="${eblRowCount+1}"/>"><c:out value="${currRow.bean.studySubject.gender}"/>&nbsp;</td>

            <c:set var="groupCount" value="3"/>
            <c:forEach var="group" items="${currRow.bean.studyGroups}">
                <td class="table_cell" rowspan="<c:out value="${eventCount}"/>" style="display: none" id="Groups_0_<c:out value="${groupCount}"/>_<c:out value="${eblRowCount+1}"/>"><c:out value="${group.studyGroupName}"/>&nbsp;</td>
                <c:set var="groupCount" value="${groupCount+1}"/>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</c:if>



<!-- <td class="table_cell"><c:out value="${count+1}"/></td>-->
<c:set var="crfIsHidden" value="${param.hideCRFs}" />
<c:set var="altMessage">
    <fmt:message key="crf_is_hidden" bundle="${resword}"/>
</c:set>
<td class="table_cell_shaded">
    <div class="clinexia-schedule-cell">
        <div class="clinexia-schedule-visit">
            <div class="clinexia-schedule-visit-header">
                <span class="clinexia-schedule-status
                    <c:choose>
                        <c:when test="${event.studyEvent.subjectEventStatus.id == 4 || event.studyEvent.subjectEventStatus.id == 8}">clinexia-schedule-status-completed</c:when>
                        <c:when test="${event.studyEvent.subjectEventStatus.id == 2}">clinexia-schedule-status-empty</c:when>
                        <c:when test="${event.studyEvent.subjectEventStatus.id == 5 || event.studyEvent.subjectEventStatus.id == 6 || event.studyEvent.subjectEventStatus.id == 7}">clinexia-schedule-status-warning</c:when>
                        <c:otherwise>clinexia-schedule-status-active</c:otherwise>
                    </c:choose>
                "><c:out value="${event.studyEvent.subjectEventStatus.name}"/></span>
            </div>
            <div class="clinexia-schedule-actions">
                <c:choose>
                    <c:when test="${event.studyEvent.id > 0}">
                        <c:choose>
                            <c:when test="${not empty eventDefCRFs}">
                                <a class="clinexia-inline-action clinexia-inline-action-main clinexia-inline-action-primary" href="EnterDataForStudyEvent?eventId=<c:out value='${event.studyEvent.id}'/>">Open Form</a>
                            </c:when>
                            <c:otherwise>
                                <a class="clinexia-inline-action clinexia-inline-action-main clinexia-inline-action-primary" href="EnterDataForStudyEvent?eventId=<c:out value='${event.studyEvent.id}'/>">Open Visit</a>
                            </c:otherwise>
                        </c:choose>
                        <div class="clinexia-schedule-secondary-actions">
                            <c:if test="${not empty eventDefCRFs}">
                                <a class="clinexia-inline-action" href="EnterDataForStudyEvent?eventId=<c:out value='${event.studyEvent.id}'/>">Open Visit</a>
                            </c:if>
                            <c:if test="${empty eventDefCRFs}">
                                <span class="clinexia-inline-empty">No form assigned</span>
                            </c:if>
                            <c:if test="${(userRole.director || userBean.sysAdmin) && study.status.available && event.studyEvent.editable}">
                                <a class="clinexia-inline-action" href="UpdateStudyEvent?event_id=<c:out value='${event.studyEvent.id}'/>&ss_id=<c:out value='${currRow.bean.studySubject.id}'/>">Edit</a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <span class="clinexia-inline-empty">No form assigned</span>
                        <c:if test="${module != 'submit' || !userRole.monitor}">
                            <a class="clinexia-inline-action clinexia-inline-action-main clinexia-inline-action-primary" href="CreateNewStudyEvent?studySubjectId=<c:out value='${currRow.bean.studySubject.id}'/>&studyEventDefinition=<c:out value='${event.studyEvent.studyEventDefinition.id}'/>">Schedule Visit</a>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</td>
<td class="table_cell"><fmt:formatDate value="${event.studyEvent.dateStarted}" pattern="${dteFormat}"/>&nbsp;</td>
<c:choose>

    <c:when test="${empty event.allEventCRFs}">
        <c:set var="edcNum" value="0"/>
        
        <c:forEach var="edc" items="${eventDefCRFs}">
            <c:if test="${! edc.hidden}">
            <td class="table_cell_shaded">
                <c:choose>
                    <c:when test="${currRow.bean.studySubject.status.id != 5 && currRow.bean.studySubject.status.id != 7}">
                        <img name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${eventCRFNum-1}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/icon_NotStarted.gif" border="0">
                    </c:when>
                    <c:otherwise>
                        <img name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${eventCRFNum-1}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/icon_Invalid.gif" border="0">
                    </c:otherwise>
                </c:choose>
                </a>
            </td>
            </c:if>
            <c:set var="edcNum" value="${edcNum+1}"/>

        </c:forEach>
    </c:when>
    <c:otherwise>
        <c:set var="crfCount" value="${0}"/>
        <c:forEach var="dec" items="${event.allEventCRFs}">

            <td class="table_cell_shaded">
                    <%-- The event definition specifies that a CRF should be hidden from a
              user logged in at the site level--%>
                <%--<c:set var="crfIsHidden" value="${dec.eventDefinitionCRF.hidden}" />
                <c:set var="altMessage">
                    <fmt:message key="crf_is_hidden" bundle="${resword}"/>
                </c:set>--%>
                <c:choose>
                    <c:when test="${dec.eventCRF.id > 0}">
                        <%--<c:if test="${! crfIsHidden}">--%>
                     <%--   </c:if>--%>
                        <c:choose>
                            <c:when test="${currRow.bean.studySubject.status.id != 5 && currRow.bean.studySubject.status.id != 7}">
                                <c:choose>
                                    <c:when test="${dec.stage.locked || event.studyEvent.subjectEventStatus.id==7}">
                                        <%-- found locked <c:out value="${event.studyEvent.subjectEventStatus.id}"/>  --%>
                                        <%-- trying to catch both dec and the entire study event locking, tbh --%>
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Locked.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:when test="${dec.stage.initialDE}">
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Started.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:when test="${dec.stage.initialDE_Complete}">
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_InitialDEcomplete.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:when test="${dec.stage.doubleDE}">
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_DDE.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:when test="${dec.stage.doubleDE_Complete}">
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Complete.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:when test="${dec.stage.admin_Editing}">
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Complete.gif" border="0">
                                        </a>
                                    </c:when>

                                    <c:otherwise>
                                        <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Invalid.gif" border="0">
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <img alt="" title="" name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Invalid.gif" border="0">
                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    <c:otherwise>
                        <%-- a little amount of back scratching here to send the correct message to eventCrfLayer.jsp, 'locked' or 'Not Started' --%>
                        <c:choose>
                            <c:when test="${event.studyEvent.subjectEventStatus.id==7}">
                                <c:set var="crfStatusName">locked</c:set>
                            </c:when>
                            <c:otherwise>
                                <c:set var="crfStatusName">Not Started</c:set>
                            </c:otherwise>
                        </c:choose>
                        <%-- note that the below is for all events that have an ID of 0, ie they dont exist yet --%>
                        <c:choose>
                            <c:when test="${event.studyEvent.subjectEventStatus.id==7}">
                                <%-- LOCKED --%>
                                <img name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Locked.gif" border="0">
                            </c:when>
                            <c:when test="${currRow.bean.studySubject.status.id != 5 && currRow.bean.studySubject.status.id != 7}">
                                <%-- found not started <c:out value="${event.studyEvent.subjectEventStatus.id}"/> --%>
                                <%-- currRow <c:out value="${currRow.bean.studySubject.status.id}"/> --%>
                                <img name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Scheduled.gif" border="0">
                            </c:when>
                            <c:otherwise>
                                <img name="CRFicon_<c:out value="${eblRowCount+count}"/>_<c:out value="${crfCount}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Invalid.gif" border="0">
                            </c:otherwise>
                        </c:choose>
                        </a>
                    </c:otherwise>

                </c:choose>
            </td>
            <c:set var="crfCount" value="${crfCount+1}"/>
        </c:forEach>

    </c:otherwise>
</c:choose>

<c:if test="${count==0}">
    <td class="table_cell" rowspan="<c:out value="${eventCount}"/>">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <a href="ViewStudySubject?id=<c:out value="${currRow.bean.studySubject.id}"/>"
                       onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                       onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');"><img
                            name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view" bundle="${resword}"/>" align="left" hspace="6"></a>
                </td>
                <c:if test="${module == 'manage'}">
                    <c:choose>
                        <c:when test="${!currRow.bean.studySubject.status.deleted}">
                            <c:if test="${study.status.available}">
                                <td><a href="RemoveStudySubject?action=confirm&id=<c:out value="${currRow.bean.studySubject.id}"/>&subjectId=<c:out value="${currRow.bean.studySubject.subjectId}"/>&studyId=<c:out value="${currRow.bean.studySubject.studyId}"/>"
                                       onMouseDown="javascript:setImage('bt_Remove1','images/bt_Remove_d.gif');"
                                       onMouseUp="javascript:setImage('bt_Remove1','images/bt_Remove.gif');"><img
                                        name="bt_Remove1" src="images/bt_Remove.gif" border="0" alt="<fmt:message key="remove" bundle="${resword}"/>" title="<fmt:message key="remove" bundle="${resword}"/>" align="left" hspace="6"></a>
                                </td>
                                <td><a href="ReassignStudySubject?id=<c:out value="${currRow.bean.studySubject.id}"/>"
                                       onMouseDown="javascript:setImage('bt_Reassign1','images/bt_Reassign_d.gif');"
                                       onMouseUp="javascript:setImage('bt_Reassign1','images/bt_Reassign.gif');"><img
                                        name="bt_Reassign1" src="images/bt_Reassign.gif" border="0" alt="<fmt:message key="reassign" bundle="${resword}"/>" title="<fmt:message key="reassign" bundle="${resword}"/>" align="left" hspace="6"></a>
                                </td>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${study.status.available}">
                                <td>
                                    <a href="RestoreStudySubject?action=confirm&id=<c:out value="${currRow.bean.studySubject.id}"/>&subjectId=<c:out value="${currRow.bean.studySubject.subjectId}"/>&studyId=<c:out value="${currRow.bean.studySubject.studyId}"/>"
                                       onMouseDown="javascript:setImage('bt_Restor3','images/bt_Restore_d.gif');"
                                       onMouseUp="javascript:setImage('bt_Restore3','images/bt_Restore.gif');"><img
                                            name="bt_Restore3" src="images/bt_Restore.gif" border="0" alt="<fmt:message key="restore" bundle="${resword}"/>" title="<fmt:message key="restore" bundle="${resword}"/>" align="left" hspace="6"></a>
                                </td>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </tr>
        </table>
    </td>
</c:if>
<c:set var="count" value="${count+1}"/>
</tr>

</c:forEach>

</c:when>

<c:otherwise>
    <tr valign="top">
        <c:choose>
            <c:when test ="${currRow.sortingColumn >= 1 && currRow.sortingColumn < groups}">
                <%-- added width tag here, fix for complaint for narrow columns, tbh --%>
                <td class="table_cell_left" width="64"><c:out value="${currRow.bean.studySubject.label}"/>&nbsp;</td>
                <td class="table_cell" style="display: all" id="Groups_0_1_<c:out value="${eblRowCount+1}"/>">
                    <c:choose>
                        <c:when test="${currRow.bean.studySubject.status.id==1}">
                            <fmt:message key="active" bundle="${resword}"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="inactive" bundle="${resword}"/>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td class="table_cell" style="display: all" id="Groups_0_2_<c:out value="${eblRowCount+1}"/>">
                    <c:out value="${currRow.bean.studySubject.gender}"/>&nbsp;
                </td>
                <c:set var="groupCount" value="3"/>
                <c:forEach var="group" items="${currRow.bean.studyGroups}">
                    <td class="table_cell" style="display: all" id="Groups_0_<c:out value="${groupCount}"/>_<c:out value="${eblRowCount+1}"/>"><c:out value="${group.studyGroupName}"/>&nbsp;</td>
                    <c:set var="groupCount" value="${groupCount+1}"/>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <%-- added width tag here, fix for complaint for narrow columns, tbh --%>
                <td class="table_cell_left" width="64"><c:out value="${currRow.bean.studySubject.label}"/>&nbsp;</td>
                <td class="table_cell" style="display: none" id="Groups_0_1_<c:out value="${eblRowCount+1}"/>">
                    <c:choose>
                        <c:when test="${currRow.bean.studySubject.status.id==1}">
                            <fmt:message key="active" bundle="${resword}"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="inactive" bundle="${resword}"/>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td class="table_cell" style="display: none" id="Groups_0_2_<c:out value="${eblRowCount+1}"/>">
                    <c:out value="${currRow.bean.studySubject.gender}"/>&nbsp;
                </td>

                <c:set var="groupCount" value="3"/>
                <c:forEach var="group" items="${currRow.bean.studyGroups}">
                    <td class="table_cell" style="display: none" id="Groups_0_<c:out value="${groupCount}"/>_<c:out value="${eblRowCount+1}"/>"><c:out value="${group.studyGroupName}"/>&nbsp;</td>
                    <c:set var="groupCount" value="${groupCount+1}"/>
                </c:forEach>

            </c:otherwise>
        </c:choose>
        <!-- <td class="table_cell">&nbsp;</td>-->

        <td class="table_cell_shaded">
            <div class="clinexia-schedule-cell">
                <div class="clinexia-schedule-visit">
                    <div class="clinexia-schedule-visit-header">
                        <span class="clinexia-schedule-status clinexia-schedule-status-empty">Not Scheduled</span>
                    </div>
                    <div class="clinexia-schedule-actions">
                        <span class="clinexia-inline-empty">No form assigned</span>
                        <c:if test="${module != 'submit' || !userRole.monitor}">
                            <a class="clinexia-inline-action clinexia-inline-action-main clinexia-inline-action-primary" href="CreateNewStudyEvent?studySubjectId=<c:out value='${currRow.bean.studySubject.id}'/>&studyEventDefinition=<c:out value='${event.studyEventDefinition.id}'/>">Schedule Visit</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </td>

        <td class="table_cell">&nbsp;</td>

            <%--<c:forEach begin="1" end="${eventCRFNum}">--%>

        <c:set var="edcNum" value="0"/>
        <c:forEach var="edc" items="${eventDefCRFs}">
            <td class="table_cell_shaded">
                <c:choose>
                    <c:when test="${currRow.bean.studySubject.status.id != 5 && currRow.bean.studySubject.status.id != 7}">
                        <img name="CRFicon_<c:out value="${eblRowCount}"/>_<c:out value="${eventCRFNum-1}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Scheduled.gif" border="0">
                    </c:when>
                    <c:otherwise>
                        <img name="CRFicon_<c:out value="${eblRowCount}"/>_<c:out value="${eventCRFNum-1}"/>_<c:out value="${currRow.bean.studySubject.label}"/>" src="images/CRF_status_icon_Invalid.gif" border="0">
                    </c:otherwise>
                </c:choose>
                </a>
            </td>
            <c:set var="edcNum" value="${edcNum+1}"/>

        </c:forEach>
        <td class="table_cell">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>

                        <a href="ViewStudySubject?module=<c:out value="${module}"/>&id=<c:out value="${currRow.bean.studySubject.id}"/>"
                           onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
                           onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');"><img
                                name="bt_View1" src="images/bt_View.gif" border="0" alt="<fmt:message key="view" bundle="${resword}"/>" align="left" hspace="6"></a>
                    </td>
                    <c:if test="${module == 'manage'}">
                        <c:choose>

                            <c:when test="${!currRow.bean.studySubject.status.deleted}">
                                <c:if test="${study.status.available}">
                                    <td><a href="RemoveStudySubject?action=confirm&id=<c:out value="${currRow.bean.studySubject.id}"/>&subjectId=<c:out value="${currRow.bean.studySubject.subjectId}"/>&studyId=<c:out value="${currRow.bean.studySubject.studyId}"/>"
                                           onMouseDown="javascript:setImage('bt_Remove1','images/bt_Remove_d.gif');"
                                           onMouseUp="javascript:setImage('bt_Remove1','images/bt_Remove.gif');"><img
                                            name="bt_Remove1" src="images/bt_Remove.gif" border="0" alt="<fmt:message key="remove" bundle="${resword}"/>" title="<fmt:message key="remove" bundle="${resword}"/>" align="left" hspace="6"></a>
                                    </td>
                                    <td>
                                        <a href="ReassignStudySubject?id=<c:out value="${currRow.bean.studySubject.id}"/>"
                                           onMouseDown="javascript:setImage('bt_Reassign1','images/bt_Reassign_d.gif');"
                                           onMouseUp="javascript:setImage('bt_Reassign1','images/bt_Reassign.gif');"><img
                                                name="bt_Reassign1" src="images/bt_Reassign.gif" border="0" alt="<fmt:message key="reassign" bundle="${resword}"/>" title="<fmt:message key="reassign" bundle="${resword}"/>" align="left" hspace="6"></a>
                                    </td>
                                </c:if>
                            </c:when>

                            <c:otherwise>
                                <c:if test="${study.status.available}">
                                    <td>
                                        <a href="RestoreStudySubject?action=confirm&id=<c:out value="${currRow.bean.studySubject.id}"/>&subjectId=<c:out value="${currRow.bean.studySubject.subjectId}"/>&studyId=<c:out value="${currRow.bean.studySubject.studyId}"/>"
                                           onMouseDown="javascript:setImage('bt_Restor3','images/bt_Restore_d.gif');"
                                           onMouseUp="javascript:setImage('bt_Restore3','images/bt_Restore.gif');"><img
                                                name="bt_Restore3" src="images/bt_Restore.gif" border="0" alt="<fmt:message key="restore" bundle="${resword}"/>" title="<fmt:message key="restore" bundle="${resword}"/>" align="left" hspace="6"></a>
                                    </td>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </tr>
            </table>
        </td>
    </tr>

</c:otherwise>
</c:choose>
