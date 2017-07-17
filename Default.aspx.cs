using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Globalization;

public class IeCompatibilityModeDisabler : IHttpModule
{
  public void Init(HttpApplication context)
  {
    context.PreSendRequestHeaders += (sender, e) => DisableCompatibilityModeIfApplicable();
  }

  private void DisableCompatibilityModeIfApplicable()
  {
    if (IsIe && IsPage)
    {
      DisableCompatibilityMode();
    }
  }

  private void DisableCompatibilityMode()
  {
    var response = Context.Response;
    response.AddHeader("X-UA-Compatible", "IE=edge");
  }

  private bool IsIe { get { return Context.Request.Browser.IsBrowser("IE"); } }

  private bool IsPage { get { return Context.Handler is Page; } }

  private HttpContext Context { get { return HttpContext.Current; } }

  public void Dispose() { }
}


public partial class _Default : System.Web.UI.Page
{
  protected string strEmail { get; set; }
  protected string strUserID_ID { get; set; }
  protected string strUserID_SSO { get; set; }
  protected string strUserID_TempID { get; set; }
  protected string strUserID_UPM { get; set; }
  protected string strOrgID { get; set; }
  protected string strOrgTemp { get; set; }
  protected string strOrgTempID { get; set; }
  protected string strOrgTempName { get; set; }
  protected string strTokenUser { get; set; }
  protected string strTokenPass { get; set; }
  protected string strOrgAccessRequested { get; set; }
  protected string strOrgModAccessRequested { get; set; }
  protected string strOrgLicAccessRequested { get; set; }
  protected string strOrgMembershipUserID { get; set; }
  protected string strOrganisationRequest { get; set; }
  protected string strDateUserPasswordExpiry { get; set; }
  protected string strDateRegistered { get; set; }
  protected string strDatePasswordResetToken { get; set; }
  protected string strDateToday { get; set; }
  protected string strDateRegistrationValidTimeRemaining { get; set; }
  protected string strDateUserPasswordChanged { get; set; }
  
  protected string strEventTypeRejected { get; set; }
  protected string strJSON { get; set; }
  protected DateTime? dtDateUserPasswordExpiry { get; set; }
  protected DateTime? dtDateToday { get; set; }
  protected DateTime dtDateUserPasswordExpiryForSubtraction { get; set; }
  protected DateTime dtDateRegistered { get; set; }
  protected DateTime dtDatePasswordResetToken { get; set; }
  protected TimeSpan tsDateRegistrationValidTimeRemaining { get; set; }
  protected TimeSpan tsDatePasswordResetTokenTimeRemaining { get; set; }
  protected TimeSpan tsDatePasswordExpiryLessDatePasswordReset { get; set; }
  protected int passwordReset_Expiry_DifferenceInDays { get; set; }

  protected double daysUntilChristmas;

  protected void Page_Load(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      userPrompt.Text = "Please enter an email address to search:";
      divTokens.Visible = false;
      divSeperatorCurrent.Visible = false;
      divSeperatorPending.Visible = false;
      divSeperatorLicences.Visible = false;
      divSeperatorTokens.Visible = false;
      divPasswordExpiry.Visible = false;
      divEmailNotFound.Visible = false;
      divUserNoConfirmationClicked.Visible = false;
      divUserConfirmSignedNoStep1.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
      divUserConfirmSignedStep2.Visible = false;
      divUserConfirmSignedLAStep2.Visible = false;
      divUserConfirmSignedStep3.Visible = false;
      divUserConfirmSignedLAStep3.Visible = false;
      divUserRejectedLA.Visible = false;
      divOrgRejected.Visible = false;
      divUserNewOrgCreate.Visible = false;
      divUserRegCompleteNoApproval.Visible = false;
      divUserRegCompleteNoApprovalLA.Visible = false;
      divUserEPAStep1.Visible = false;
      divUserEPAStep2.Visible = false;
      //divUserEPAStep3.Visible = false;
      divModuleAccessPending.Visible = false;
      divRegistrationExpiry.Visible = false;
      divPasswordResetTokenExpiry.Visible = false;
      divPasswordReset.Visible = false;
      YearLabel.Text = DateTime.Now.Year.ToString();
    }
  }

  protected void btnEmail_Click(object sender, EventArgs e)
  {

    strEmail = txtEmail.Text;

    DataSourceSelectArguments srUserID_IDStr = new DataSourceSelectArguments();
    DataView dvUserID_IDStr = (DataView)SqlDataSource5.Select(srUserID_IDStr);
    if (dvUserID_IDStr.Count != 0)
    {
      strUserID_ID = dvUserID_IDStr[0][0].ToString();
    }

    DataSourceSelectArguments srUserID_SSOStr = new DataSourceSelectArguments();
    DataView dvUserID_SSOStr = (DataView)SqlDataSource14.Select(srUserID_SSOStr);
    if (dvUserID_SSOStr.Count != 0)
    {
      strUserID_SSO = dvUserID_SSOStr[0][0].ToString();
    }

    DataSourceSelectArguments srTokenUser = new DataSourceSelectArguments();
    DataView dvTokenUser = (DataView)SqlDataSource4.Select(srTokenUser);
    if (dvTokenUser.Count != 0)
    {
      strTokenUser = dvTokenUser[0][0].ToString();
    }

    DataSourceSelectArguments srTokenPassStr = new DataSourceSelectArguments();
    DataView dvTokenPassStr = (DataView)SqlDataSource12.Select(srTokenPassStr);
    if (dvTokenPassStr.Count != 0)
    {
      strTokenPass = dvTokenPassStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgTempStr = new DataSourceSelectArguments();
    DataView dvOrgTempStr = (DataView)SqlDataSource110.Select(srOrgTempStr);
    if (dvOrgTempStr.Count != 0)
    {
      strOrgTemp = dvOrgTempStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgTempIDStr = new DataSourceSelectArguments();
    DataView dvOrgTempIDStr = (DataView)SqlDataSource118.Select(srOrgTempIDStr);
    if (dvOrgTempIDStr.Count != 0)
    {
      strOrgTempID = dvOrgTempIDStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgTempNameStr = new DataSourceSelectArguments();
    DataView dvOrgTempNameStr = (DataView)SqlDataSource124.Select(srOrgTempNameStr);
    if (dvOrgTempNameStr.Count != 0)
    {
      strOrgTempName = dvOrgTempNameStr[0][0].ToString();
    }
       

    DataSourceSelectArguments srOrgIDStr = new DataSourceSelectArguments();
    DataView dvOrgIDStr = (DataView)SqlDataSource111.Select(srOrgIDStr);
    if (dvOrgIDStr.Count != 0)
    {
      strOrgID = dvOrgIDStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgAccessRequestedStr = new DataSourceSelectArguments();
    DataView dvOrgAccessRequestedStr = (DataView)SqlDataSource112.Select(srOrgAccessRequestedStr);
    if (dvOrgAccessRequestedStr.Count != 0)
    {
      strOrgAccessRequested = dvOrgAccessRequestedStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgModAccessRequestedStr = new DataSourceSelectArguments();
    DataView dvOrgModAccessRequestedStr = (DataView)SqlDataSource113.Select(srOrgModAccessRequestedStr);
    if (dvOrgModAccessRequestedStr.Count != 0)
    {
      strOrgModAccessRequested = dvOrgModAccessRequestedStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgLicAccessRequestedStr = new DataSourceSelectArguments();
    DataView dvOrgLicAccessRequestedStr = (DataView)SqlDataSource114.Select(srOrgLicAccessRequestedStr);
    if (dvOrgLicAccessRequestedStr.Count != 0)
    {
      strOrgLicAccessRequested = dvOrgLicAccessRequestedStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrgMembershipUserIDStr = new DataSourceSelectArguments();
    DataView dvOrgMembershipUserIDStr = (DataView)SqlDataSource115.Select(srOrgMembershipUserIDStr);
    if (dvOrgMembershipUserIDStr.Count != 0)
    {
      strOrgMembershipUserID = dvOrgMembershipUserIDStr[0][0].ToString();
    }

    DataSourceSelectArguments srUserPasswordExpiryDt = new DataSourceSelectArguments();
    DataView dvUserPasswordExpiryDt = (DataView)SqlDataSource116.Select(srUserPasswordExpiryDt);
    if (dvUserPasswordExpiryDt.Count != 0)
    {
      strDateUserPasswordExpiry = dvUserPasswordExpiryDt[0][0].ToString();
    }

    DataSourceSelectArguments srUserPasswordChangedDt = new DataSourceSelectArguments();
    DataView dvUserPasswordChangedDt = (DataView)SqlDataSource126.Select(srUserPasswordChangedDt);
    if (dvUserPasswordChangedDt.Count != 0)
    {
      strDateUserPasswordChanged = dvUserPasswordChangedDt[0][0].ToString();
    }

    

    DataSourceSelectArguments srUserPasswordResetTokenDt = new DataSourceSelectArguments();
    DataView dvUserPasswordResetTokenDt = (DataView)SqlDataSource122.Select(srUserPasswordResetTokenDt);
    if (dvUserPasswordResetTokenDt.Count != 0)
    {
      strDatePasswordResetToken = dvUserPasswordResetTokenDt[0][0].ToString();
    }    

    DataSourceSelectArguments srDateRegisteredDt = new DataSourceSelectArguments();
    DataView dvDateRegisteredDt = (DataView)SqlDataSource121.Select(srDateRegisteredDt);
    if (dvDateRegisteredDt.Count != 0)
    {
      strDateRegistered = dvDateRegisteredDt[0][0].ToString();
    }

    DataSourceSelectArguments srUserTempDetailsStr = new DataSourceSelectArguments();
    DataView dvUserTempDetailsStr = (DataView)SqlDataSource117.Select(srUserTempDetailsStr);
    if (dvUserTempDetailsStr.Count != 0)
    {
      strUserID_TempID = dvUserTempDetailsStr[0][0].ToString();
    }

    DataSourceSelectArguments srOrganisationRequestStr = new DataSourceSelectArguments();
    DataView dvOrganisationRequestStr = (DataView)SqlDataSource119.Select(srOrganisationRequestStr);
    if (dvOrganisationRequestStr.Count != 0)
    {
      strOrganisationRequest = dvOrganisationRequestStr[0][0].ToString();
    }


    DataSourceSelectArguments srUserID_UPMStr = new DataSourceSelectArguments();
    DataView dvUserID_UPMStr = (DataView)SqlDataSource120.Select(srUserID_UPMStr);
    if (dvUserID_UPMStr.Count != 0)
    {
      strUserID_UPM = dvUserID_UPMStr[0][0].ToString();
    }


    DataSourceSelectArguments srEventTypeRejectedStr = new DataSourceSelectArguments();
    DataView dvEventTypeRejectedStr = (DataView)SqlDataSource123.Select(srEventTypeRejectedStr);
    if (dvEventTypeRejectedStr.Count != 0)
    {
      strEventTypeRejected = dvEventTypeRejectedStr[0][0].ToString();
    }


    

    dtDateToday = DateTime.Now;

    /*
     * Password expiry notification and countdown
     * 
     */

    dtDateUserPasswordExpiry = null;

    if (!string.IsNullOrEmpty(strDateUserPasswordExpiry))
    {
      dtDateUserPasswordExpiry = DateTime.ParseExact(strDateUserPasswordExpiry, "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
      dtDateUserPasswordExpiryForSubtraction = DateTime.ParseExact(strDateUserPasswordExpiry, "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
    }
    if (dtDateUserPasswordExpiry != null && dtDateToday > dtDateUserPasswordExpiry && strOrgID != "7c310be0-c20f-de11-b526-0022642a33b2")
    {
      divPasswordExpiry.Visible = true;
      lblPasswordExpiry.Text = "EDEN password has expired";
      lblPasswordExpiry.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divPasswordExpiry.Visible = false;
    }

    /*
     * Registration expiry 
     * 
     */

    if (!string.IsNullOrEmpty(strDateRegistered))
    {
      dtDateRegistered = DateTime.ParseExact(strDateRegistered, "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
      tsDateRegistrationValidTimeRemaining = dtDateRegistered.AddHours(+24).Subtract(DateTime.Now);
    }

    if (strUserID_SSO == null && dtDateRegistered != null && strDateRegistered != null && dtDateRegistered < DateTime.Now.AddHours(-24))
    {
      divRegistrationExpiry.Visible = true;
      lblRegistrationExpiry.Text = "<i>Registration token has expired.</i> <br />- User's registration must be deleted to allow re-registration";
      lblRegistrationExpiry.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divRegistrationExpiry.Visible = false;
    }

    if (strUserID_SSO == null && dtDateRegistered != null && strDateRegistered != null && dtDateRegistered > DateTime.Now.AddHours(-24))
    {
      divRegistrationExpiry.Visible = true;
      lblRegistrationExpiry.Text = "Registration token is valid.<br />- The account verification link can be copied and emailed to the user if the notification has been blocked or re-routed. <br/>- This link is valid until " + dtDateRegistered.AddHours(+24) + ". Remaining time: <b>" + tsDateRegistrationValidTimeRemaining.ToString(@"hh\:mm") + "</b> hours";
      lblRegistrationExpiry.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }
    else
    {
      divRegistrationExpiry.Visible = false;
    }

    if (dtDateRegistered == null)
    {
      divRegistrationExpiry.Visible = false;
    }

    if (strUserID_SSO != null)
    {
      divRegistrationExpiry.Visible = false;
    }



    /*
     * Password reset token expiry 
     * 
     */
    //dtDatePasswordResetToken='';
    if (!string.IsNullOrEmpty(strDatePasswordResetToken))
    {
      dtDatePasswordResetToken = DateTime.ParseExact(strDatePasswordResetToken, "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
      tsDatePasswordResetTokenTimeRemaining = dtDatePasswordResetToken.AddHours(+24).Subtract(DateTime.Now);
    }

    if (strUserID_SSO != null && dtDatePasswordResetToken != null && strDatePasswordResetToken != null && dtDatePasswordResetToken < DateTime.Now.AddHours(-24))
    {
      divPasswordResetTokenExpiry.Visible = true;
      lblPasswordResetTokenExpiry.Text = "<br /><i>Password reset token has expired.</i> <br />- The user will need to be begin the password reset process again and generate a new token.";
      lblPasswordResetTokenExpiry.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divPasswordResetTokenExpiry.Visible = false;
    }

    if (strUserID_SSO != null && dtDatePasswordResetToken != null && dtDatePasswordResetToken > DateTime.Now.AddHours(-24))
    {
      divPasswordResetTokenExpiry.Visible = true;
      lblPasswordResetTokenExpiry.Text = "<br />Password reset token is valid.<br />- The password reset token can be copied and emailed to the user.<br/>- This token is valid until " + dtDatePasswordResetToken.AddHours(+24) + ". Remaining time: <b>" + tsDatePasswordResetTokenTimeRemaining.ToString(@"hh\:mm") + "</b> hours (after which the user will need to be begin the password reset process again and generate a new token).";
      lblPasswordResetTokenExpiry.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }

    if (dtDatePasswordResetToken == null)
    {
      divPasswordResetTokenExpiry.Visible = false;
    }

    if (strUserID_ID == null
      && strUserID_SSO == null
      && strUserID_TempID == null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID == null
      && strTokenUser == null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divEmailNotFound.Visible = true;
      lblEmailNotFound.Text = "Email address not found";
      lblEmailNotFound.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divEmailNotFound.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO == null
      && strUserID_TempID == null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID == null
      && strTokenUser != null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divUserNoConfirmationClicked.Visible = true;
      lblUserNoConfirmationClicked.Text = "Status: User has not clicked confirmation email and signed in";
      lblUserNoConfirmationClicked.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserNoConfirmationClicked.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID == null
      && strTokenUser != null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divUserConfirmSignedNoStep1.Visible = true;
      lblUserConfirmSignedNoStep1.Text = "Status: EDEN Portal Access Request - Step 1: User has clicked confirmation email, but has not selected an organisation";
      lblUserConfirmSignedNoStep1.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserConfirmSignedNoStep1.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID != null
      && strTokenUser != null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divUserConfirmSignedStep2.Visible = true;
      divUserConfirmTempOrgDetails.Visible = true;
      lblUserConfirmSignedStep2.Text = "Status: EDEN Portal Access Request - Step 2: User has selected an organisation, but has not yet added their personal and contact details";
      lblUserConfirmSignedStep2.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserConfirmSignedStep2.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strOrgID == null
      && strOrgTemp != null
      && strTokenUser != null
      )
    {
      divUserConfirmSignedLAStep2.Visible = true;
      divUserConfirmTempOrgDetails.Visible = true;
      lblUserConfirmSignedLAStep2.Text = "Status: EDEN Portal Access Request - Step 2: User has selected an organisation, but has not yet added their personal and contact details";
      lblUserConfirmSignedLAStep2.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserConfirmSignedLAStep2.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID != null
      && strOrgAccessRequested == null
      && strTokenUser != null
      && strOrgMembershipUserID == null
      && strEventTypeRejected != "Organisation Membership Request Rejected"
      )
    {
      divUserConfirmSignedStep3.Visible = true;
      divUserConfirmTempOrgDetails.Visible = true;
      lblUserConfirmSignedStep3.Text = "Status: EDEN Portal Access Request - Step 3: User has selected an organisation, but has not yet selected a module and submitted the access request";
      lblUserConfirmSignedStep3.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserConfirmSignedStep3.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
    }

    //if (strUserID_SSO != null && strOrgID == null && strUserID_TempID != null && strOrgTemp != null && strOrgAccessRequested == null)
    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strOrgID == null
      && strOrgTemp != null
      && strOrgAccessRequested == null
      && strTokenUser != null
      && strOrgMembershipUserID == null
      && strOrganisationRequest == null
      && strEventTypeRejected == null
      )
    {
      divUserConfirmSignedLAStep3.Visible = true;
      divUserConfirmTempOrgDetails.Visible = true;
      lblUserConfirmSignedLAStep3.Text = "Status: EDEN Portal Access Request - Step 3: User has selected an organisation, but has not yet selected a module and submitted the access request";
      lblUserConfirmSignedLAStep3.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserConfirmSignedLAStep3.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strOrgID == null
      && strOrgTemp != null
      && strOrgAccessRequested == null
      && strTokenUser != null
      && strOrgMembershipUserID == null
      && strOrganisationRequest != null
      )
    {
      divUserNewOrgCreate.Visible = true;
      lblUserNewOrgCreate.Text = "Status: User has selected a module and requested to register a <i>new</i> organisation on EDEN. The request is now with the EPA for approval";
      lblUserNewOrgCreate.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }
    else
    {
      divUserNewOrgCreate.Visible = false;
    }

    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID != null
      && strOrgAccessRequested != null
      && strTokenUser != null
      && strOrgMembershipUserID == null
      )
    {
      divUserRegCompleteNoApproval.Visible = true;
      divUserConfirmTempOrgDetails.Visible = true;
      lblUserRegCompleteNoApproval.Text = "Status: User has selected an organisation, selected a module and submitted the access request. The org admin(s) can now process this request";
      lblUserRegCompleteNoApproval.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }
    else
    {
      divUserRegCompleteNoApproval.Visible = false;
      divUserConfirmTempOrgDetails.Visible = false;
    }

    //if (strUserID_SSO != null && strOrgID == null && strUserID_TempID != null && strOrgTemp != null && strOrgAccessRequested != null)
    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strOrgID == null
      && strOrgTemp != null
      && strOrgAccessRequested != null
      && strTokenUser != null
      && strOrgMembershipUserID == null
      )
    {
      divUserRegCompleteNoApprovalLA.Visible = true;
      lblUserRegCompleteNoApprovalLA.Text = "Status: User has selected an organisation, selected a module and submitted the access request. The org admin(s) can now process this request";
      lblUserRegCompleteNoApprovalLA.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }
    else
    {
      divUserRegCompleteNoApprovalLA.Visible = false;
    }



    if (strOrgModAccessRequested!=null && strOrgID!=null)
    {
      divModuleAccessPending.Visible = true;
      lblModuleAccessPending.Text = "Status: One or more module access requests by this user currently Pending Approval";
      lblModuleAccessPending.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divModuleAccessPending.Visible = false;
    }
    
    if (strOrgID != null)
    {
      divUserConfirmSignedNoStep1.Visible = false;
    }

    if (strUserID_TempID!=null)
    {
      divPasswordExpiry.Visible = false;
    }

    if (strOrgModAccessRequested!=null && strOrgLicAccessRequested!=null)
    {
      GridView16.Visible = true;
      GridView17.Visible = false;
    }

    if (strOrgModAccessRequested == strOrgLicAccessRequested)
    {
      GridView16.Visible = true;
      GridView17.Visible = true;
    }

    if (strOrgMembershipUserID == null)
    {
      GridView23.Visible = true;
    }
    else
    {
      GridView23.Visible = false;
    }


    if (strOrgMembershipUserID == null)
    {
      GridView22.Visible = true;
    }
    else
    {
      GridView22.Visible = false;
    }

    if (strUserID_SSO == null & strTokenUser != null)
    {
      divVerificationLink.Visible = true;
    }
    else
    {
      divVerificationLink.Visible = false;
    }

    if (strUserID_SSO != null)
    {
      divVerificationLink.Visible = false;
    }

    if (strUserID_SSO != null)
    {
      divUserExternalLinks.Visible = true;
    }
    else
    {
      divUserExternalLinks.Visible = false;
    }

    if (strTokenPass == null)
    {
      divPasswordReset.Visible = false;
    }
    else
    {
      divPasswordReset.Visible = true;
    }


    /*
     * EPA Users
     */

    if (strUserID_ID == null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strUserID_UPM != null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID == null
      && strTokenUser == null
      && strTokenPass == null
      && strOrgAccessRequested == null
      && strOrgModAccessRequested == null
      && strOrgLicAccessRequested == null
      && strOrgMembershipUserID == null
      && strOrganisationRequest == null
      && strEventTypeRejected == null
      )
    {
      divUserEPAStep1.Visible = true;
      lblUserEPAStep1.Text = "Status: EDEN Portal Access Request - Step 1: EPA user has signed up, but has not selected an organisation";
      lblUserEPAStep1.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserEPAStep1.Visible = false;
    }


    if (strUserID_ID == null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strUserID_UPM != null
      && strOrgTemp != null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divUserEPAStep2.Visible = true;
      lblUserEPAStep2.Text = "Status: EDEN Portal Access Request - Step 2: EPA user has selected organisation, but has not yet added their personal and contact details";
      lblUserEPAStep2.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserEPAStep2.Visible = false;
    }

    if (strUserID_ID == null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strUserID_UPM != null
      && strOrgTemp != null
      && strOrgAccessRequested == null
      && strOrgMembershipUserID == null
      )
    {
      divUserEPAStep3.Visible = true;
      lblUserEPAStep3.Text = "Status: EDEN Portal Access Request - Step 3: EPA user has added their personal and contact details, but has not yet selected a module";
      lblUserEPAStep3.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserEPAStep3.Visible = false;
    }

    if (strUserID_ID == null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strUserID_UPM != null
      && strOrgTemp != null
      && strOrgAccessRequested != null
      )
    {
      divUserRegCompleteNoApprovalEPA.Visible = true;
      lblUserRegCompleteNoApprovalEPA.Text = "EPA user has selected an organisation, selected a module and submitted the access request. The EPA org admin(s) can now process this request";
      lblUserRegCompleteNoApprovalEPA.ForeColor = System.Drawing.ColorTranslator.FromHtml("#4d9900");
    }
    else
    {
      divUserRegCompleteNoApprovalEPA.Visible = false;
    }


    if (strUserID_ID == null
      && strUserID_SSO != null
      && strUserID_TempID == null
      && strUserID_UPM != null
      && strOrgID == null
      && strOrgTemp == null
      && strOrgTempID == null
      && strTokenUser == null
      && strTokenPass == null
      && strOrgAccessRequested == null
      && strOrgModAccessRequested == null
      && strOrgLicAccessRequested == null
      && strOrgMembershipUserID == null
      && strOrganisationRequest == null
      && strEventTypeRejected == "Organisation Rejected"
      )
    {
      divUserRejectedLA.Visible = true;
      lblUserRejectedLA.Text = "Status: User has signed up, but the organisation has been <b>rejected</b><br /> - This email address must be manually deleted from the SSO to be used again to register.";
      lblUserRejectedLA.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserRejectedLA.Visible = false;
    }


    if (strUserID_ID != null
      && strUserID_SSO != null
      && strUserID_TempID != null
      && strEventTypeRejected == "Organisation Rejected"
      )
    {
      divOrgRejected.Visible = true;
      lblOrgRejected.Text = "Status: User has signed up, but the <b>organisation creation request</b> has been <b>rejected</b><br /> - This email address must be manually deleted from the SSO to be used again to register.";
      lblOrgRejected.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divOrgRejected.Visible = false;
    }


    if (
      strEventTypeRejected == "Organisation Membership Request Rejected"
      )
    {
      divUserRejectedLA.Visible = true;
      lblUserRejectedLA.Text = "Status: User has signed up, but the <b>organisation membership request</b> has been <b>rejected</b><br /> - This email address must be manually deleted from the SSO to be used again to register.";
      lblUserRejectedLA.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserRejectedLA.Visible = false;
    }


    if (
      strEventTypeRejected == "Module Authorisation Rejected"
      )
    {
      divUserRejectedLA.Visible = true;
      lblUserRejectedLA.Text = "Status: User's organisation access has been approved, but a module authorisation request has been rejected. (This may have been rectified - please check the notifications below).<br />";
      lblUserRejectedLA.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E60000");
    }
    else
    {
      divUserRejectedLA.Visible = false;
    }

    
    tsDatePasswordExpiryLessDatePasswordReset = dtDateUserPasswordExpiryForSubtraction - dtDatePasswordResetToken;
    int passwordReset_Expiry_DifferenceInDays = tsDatePasswordExpiryLessDatePasswordReset.Days;

    if (tsDatePasswordExpiryLessDatePasswordReset.Days == 90)
    {
      divPasswordResetTokenExpiry.Visible = false;
    }


    divTokens.Visible = true;
    divSeperatorCurrent.Visible = true;
    divSeperatorPending.Visible = true;
    divSeperatorLicences.Visible = true;
    divSeperatorTokens.Visible = true;
    txtCopyVerificationLink.Text  = "https://account.edenireland.ie/signup/confirmemail?userId=" + strUserID_ID + "&token=" + strTokenUser;
    txtCopyPasswordResetLink.Text = "https://account.edenireland.ie/passwordreset/resetpassword?userId=" + strUserID_SSO + "&token=" + strTokenPass;
    GridView1.DataBind();
    GridView2.DataBind();
    GridView3.DataBind();
    GridView4.DataBind();
    GridView5.DataBind();
    GridView6.DataBind();
    GridView7.DataBind();
    GridView8.DataBind();
    GridView9.DataBind();
    GridView10.DataBind();
    GridView11.DataBind();
    GridView12.DataBind();
    GridView13.DataBind();
    GridView14.DataBind();
    GridView15.DataBind();
    GridView16.DataBind();
    GridView17.DataBind();
    GridView18.DataBind();
    GridView19.DataBind();
    GridView20.DataBind();
    GridView21.DataBind();
    GridView22.DataBind();
    GridView23.DataBind();
    GridView24.DataBind();
  }


  protected void GridView2_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView2.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView2.DataSource = dataView;
      GridView2.DataBind();
    }
  }

  protected void GridView7_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView7.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView7.DataSource = dataView;
      GridView7.DataBind();
    }
  }

  protected void GridView10_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView10.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView10.DataSource = dataView;
      GridView10.DataBind();
    }
  }

  protected void GridView13_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView13.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView13.DataSource = dataView;
      GridView13.DataBind();
    }
  }


  protected void GridView18_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView18.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView18.DataSource = dataView;
      GridView18.DataBind();
    }
  }

  protected void GridView19_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView19.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView19.DataSource = dataView;
      GridView19.DataBind();
    }
  }

  protected void GridView21_Sorting(object sender, GridViewSortEventArgs e)
  {
    DataTable dataTable = GridView21.DataSource as DataTable;

    if (dataTable != null)
    {
      DataView dataView = new DataView(dataTable);
      dataView.Sort = e.SortExpression + " " + ConvertSortDirectionToSql(e.SortDirection);

      GridView21.DataSource = dataView;
      GridView21.DataBind();
    }
  }

  private string ConvertSortDirectionToSql(SortDirection sortDirection)
  {
    string newSortDirection = String.Empty;

    switch (sortDirection)
    {
      case SortDirection.Ascending:
        newSortDirection = "ASC";
        break;

      case SortDirection.Descending:
        newSortDirection = "DESC";
        break;
    }

    return newSortDirection;
  }
}




/*
 * 
 * 
 * 

//using Newtonsoft.Json;


  //protected string strEmailUnValidated { get; set; }
  //protected string strJSONNotificationBody { get; set; }

    //GridView22.DataSource = SerializeDataTable();
        
    //Response.Redirect("~/Default.aspx?q=" + strEmail, true);

    //DataSourceSelectArguments srJSONNotificationBodyStr = new DataSourceSelectArguments();
    //DataView dvJSONNotificationBodyStr = (DataView)SqlDataSource22.Select(srJSONNotificationBodyStr);
    //if (dvJSONNotificationBodyStr.Count != 0)
    //{
    //  strJSONNotificationBody = dvJSONNotificationBodyStr[0][0].ToString();
    //}

  
  //public DataTable DerializeDataTable()
  //{
  //  string json = strJSONNotificationBody; //"data" should contain your JSON 
  //  var table = JsonConvert.DeserializeObject<DataTable>(json);
  //  return table;
  //}
 
//string strEmailUnValidated;
//String steEMailSubStringToCheck = "%253c";
//strEmailUnValidated = org.apache.commons.lang3.StringEscapeUtils.unescapeJava(str); txtEmail.Text;
var charsToRemove = new string[] { "%253C", "<", ">", ";", "'" };

/*if (strEmailUnValidated.ToLower().Contains('<'))
{
  string strEmailValidated1 = strEmailUnValidated.Substring(strEmailUnValidated.IndexOf('<') + 1);

  strEmail = new string((from c in strEmailValidated1
                         where char.IsWhiteSpace(c) || char.IsLetterOrDigit(c)
                         select c
   ).ToArray());

}
else
{
  strEmail = txtEmail.Text;
}//*/
/*
if (strEmailUnValidated.Contains("%253C"))
{
  string strEmailValidated1 = strEmailUnValidated.Substring(strEmailUnValidated.IndexOf("%253C") + 1);

  foreach (var c in charsToRemove)
  {
    strEmail = strEmail.Replace(c, string.Empty);
  }
}
else
{
  strEmail = txtEmail.Text;
}
//*/