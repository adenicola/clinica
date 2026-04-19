<%@ include file="/WEB-INF/jsp/taglibs.jsp" %>

<!-- Footer -->
<div class="footer_login">
	<table  class="footer_table" >
            <tr>
                <td class="footer_left" >
                    <div class="clinexia-footer-stack">
                        <span class="clinexia-footer-brand">Clinexia</span>
                        <span class="clinexia-footer-product">Platform</span>
                    </div>
                </td>
                <td class="footer_middle" >
                    <span class="clinexia-footer-copy">Clinical operations workspace</span>
                </td>

                <td  class="footer_right">
                    <div class="clinexia-footer-version">
                        <span>Version 1.4.0-rc1</span>
                        <span>Build local</span>
                    </div>
                </td>
            </tr>
        </table>
</div>
<!-- End Footer -->

<script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery('#cancel').click(function() {
                jQuery.unblockUI();
                return false;
            });
        });

    </script>

</body>

</html>
