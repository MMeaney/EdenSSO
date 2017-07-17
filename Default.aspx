<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="utf-8" Debug="true" CodeFile="Default.aspx.cs" Inherits="_Default"  MaintainScrollPositionOnPostback="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
  <title>EDEN SSO Admin</title>
  <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <link rel="icon" href="http://epa.ie/media/favicon.ico" type="image/x-icon" />
  <link rel="shortcut icon" href="http://epa.ie/media/favicon.ico" />

  <script type="text/javascript" src="./Scripts/jquery-2.2.4.min.js"></script>
  <script type="text/javascript" src="./Scripts/bootstrap-3.3.6.min.js"></script>
  <script type="text/javascript" src="./Scripts/clipboard.min.js"></script>
    
  <link rel="stylesheet" type="text/css" href="./Content/bootstrap.min.css" />
  <link rel="stylesheet" type="text/css" href="./Content/font-awesome.min.css" />  
  <link rel="stylesheet" type="text/css" href="./Styles/site.css" />  

<style type="text/css" >
  th.sortasc a  { display: block; padding: 0 4px 0 15px; background: url(img/asc.png) no-repeat; }
  th.sortdesc a { display: block; padding: 0 4px 0 15px; background: url(img/desc.png) no-repeat; }   
</style>

</head>

<body>
<div class="wrapper">
<center>
  <div class="titledivcss">
  EDEN SSO User Check
  </div><!-- ./container-fluid -->
</center>

<div class="container">

<center>
<form id="form1" runat="server">
<div><!--Div for sticky footer -->
  <br />
  <p>
    <asp:Label id="userPrompt" runat="server"></asp:Label>
  </p>
    <asp:TextBox class="searchEmail input input-md" size="60" runat="server" id="txtEmail" /> 
    <asp:Button class="btn btn-info" id="btnEmail" runat="server" onclick="btnEmail_Click" Text="Check" />
  <br />
  <br />
</center>
<div><!-- Required for footer push -->

<!-------------------------------------------------------------------------------------------------------------------------
------ Current Access
-------------------------------------------------------------------------------------------------------------------------->

<div class="panel panel-primary" id="divSeperatorCurrent" runat="server">
<div class="panel-heading"><h3 class="panel-title">Current Access</h3></div><!-- ./panel-heading -->
  <div class="panel-body">

  <asp:GridView id="GridView1" runat="server" AllowSorting="True" caption="User Details" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataKeyNames="UserId" DataSourceID="SqlDataSource1">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UPR.Email		      AS	[Eden Email]
    , UPR.Username		AS	[Eden Username]
	  , ISNULL(UPR.Email2, '-- CRM Email - To be synced from CRM to EDEN SSO --')	 			    AS	[CRM Email]
	  , LTRIM(RTRIM(UPR.FirstName))  + ' ' + LTRIM(RTRIM(UPR.LastName))	AS	[User's Name]
    , UPR.Phone       AS  [Phone]
    , UPR.Mobile      AS  [Mobile]
	  , UMB.PasswordExpiration  AS	[Password Expiration]
	  --, UMB.PasswordChangedDate AS	[Password Changed Date]
	  , UPR.UserId
    , UPR.Active
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG		ON	ORG.OrganisationId			= OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress			OAD		ON	OAD.OrganisationId		  = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType				OTY		ON	OTY.OrganisationTypeId  = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisationRequest		MAR		ON  MAR.UserID				= UPR.UserID
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <div id="divUserExternalLinks" runat="server">
    <span class="spanUserExternalLinks">User Profile Links:
    <a href="https://www.edenireland.ie/userprofile/profilesummary?userId=<% =strUserID_SSO %>" target="blank">EDEN</a>
    |
    <a href="http://wexcrmapp:5544/EPA/main.aspx?etc=2&id=%7b<% =strUserID_SSO %>%7d&pagetype=entityrecord" target="blank">LEMA</a>
    </span>
    <br />
    <br />
  </div><!-- ./divUserExternalLinks -->

  <div id="divPasswordExpiry" runat="server">  
    <asp:Label id="lblPasswordExpiry" runat="server"></asp:Label>
    <br />
    <br />
  </div><!-- ./divPasswordExpiry -->

  <div id="divUserNoConfirmationClicked" runat="server">  
    <asp:Label id="lblUserNoConfirmationClicked" runat="server"></asp:Label>
    <br />
    <br />
  </div><!-- ./divUserNoConfirmationClicked -->

  <div id="divRegistrationExpiry" runat="server">  
    <asp:Label id="lblRegistrationExpiry" runat="server"></asp:Label>
    <br />
  </div><!-- ./divRegistrationExpiry -->

  <div id="divUserRejectedLA" runat="server">  
    <asp:Label id="lblUserRejectedLA" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserRejectedLA -->

  <div id="divOrgRejected" runat="server">  
    <asp:Label id="lblOrgRejected" runat="server"></asp:Label>
    <br />
  </div><!-- ./divOrgRejected -->

  


  <div id="divEmailNotFound" runat="server">  
    <asp:Label id="lblEmailNotFound" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserNoConfirmationClicked -->

  <div id="divUserConfirmSignedNoStep1" runat="server">  
    <asp:Label id="lblUserConfirmSignedNoStep1" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserConfirmSignedNoStep1 -->

  <div id="divUserConfirmSignedStep2" runat="server">  
    <asp:Label id="lblUserConfirmSignedStep2" runat="server"></asp:Label>
  </div><!-- ./divUserConfirmSignedStep2 -->

  <div id="divUserConfirmSignedLAStep2" runat="server">  
    <asp:Label id="lblUserConfirmSignedLAStep2" runat="server"></asp:Label>
  </div><!-- ./divUserConfirmSignedLAStep2 -->

  <div id="divUserConfirmSignedStep3" runat="server">  
    <asp:Label id="lblUserConfirmSignedStep3" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserConfirmSignedStep3 -->

  <div id="divUserConfirmSignedLAStep3" runat="server">  
    <asp:Label id="lblUserConfirmSignedLAStep3" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserConfirmSignedLAStep3 -->

  <div id="divUserNewOrgCreate" runat="server">  
    <asp:Label id="lblUserNewOrgCreate" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserNewOrgCreate -->

  <div id="divUserRegCompleteNoApproval" runat="server">  
    <asp:Label id="lblUserRegCompleteNoApproval" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserRegCompleteNoApproval -->

  <div id="divUserRegCompleteNoApprovalLA" runat="server">  
    <asp:Label id="lblUserRegCompleteNoApprovalLA" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserRegCompleteNoApprovalLA -->
  
  <div id="divUserEPAStep1" runat="server">  
    <asp:Label id="lblUserEPAStep1" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserEPAStep1 -->
  
  <div id="divUserEPAStep2" runat="server">  
    <asp:Label id="lblUserEPAStep2" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserEPAStep2 -->
  
  <div id="divUserEPAStep3" runat="server">  
    <asp:Label id="lblUserEPAStep3" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserEPAStep3 -->
  
  <div id="divUserRegCompleteNoApprovalEPA" runat="server">  
    <asp:Label id="lblUserRegCompleteNoApprovalEPA" runat="server"></asp:Label>
    <br />
  </div><!-- ./divUserRegCompleteNoApprovalEPA -->  

  <div id="divModuleAccessPending" runat="server">  
    <asp:Label id="lblModuleAccessPending" runat="server"></asp:Label>
    <br />
    <br />
  </div><!-- ./divModuleAccessPending -->

  <div id="divUserConfirmTempOrgDetails" runat="server">
  <br />  
    <span class="spanUserExternalLinks">
    Organisation requested: <a href="https://www.edenireland.ie/manage/organisation/<% =strOrgTempID %>/members" target="blank"><b><% =strOrgTempName %></b></a>
    </span>
  </div><!-- ./divUserConfirmTempOrgDetails -->



    <asp:GridView ID="GridView21" runat="server" AllowSorting="True" caption="Current Organisation Access"
        AutoGenerateColumns="False"
        showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource21" 
        onsorting="GridView21_Sorting">
    <Columns>
      <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" >
      </asp:BoundField>
      <asp:BoundField DataField="OrganisationType" HeaderText="Organisation Type" SortExpression="OrganisationType" >
      </asp:BoundField>
      <asp:TemplateField HeaderText="Default" SortExpression="Default">
        <ItemTemplate>
        <asp:CheckBox ID="cbOrgDefault" Checked='<%# Convert.ToBoolean(Eval("Default")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
      <asp:TemplateField HeaderText="Current" SortExpression="Current">
        <ItemTemplate>
        <asp:CheckBox ID="cbOrgCurrent" Checked='<%# Convert.ToBoolean(Eval("Current")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
     <asp:HyperLinkField 
        HeaderText="EDEN"
        Target="_blank"
        DataNavigateUrlFields="OrganisationId" 
        DataNavigateUrlFormatString="https://www.edenireland.ie/manage/organisation/{0}/members" 
        DataTextField="Organisation" 
        DataTextFormatString="EDEN Org Link" />  
     <asp:HyperLinkField 
        HeaderText="LEMA"
        Target="_blank"
        DataNavigateUrlFields="OrganisationId" 
        DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=1&id=%7b{0}%7d&pagetype=entityrecord"
        DataTextField="Organisation" 
        DataTextFormatString="LEMA Org Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>

  <asp:SqlDataSource ID="SqlDataSource21" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    ISNULL(ORG.Name,'-- No org approved --')	AS	[Organisation]
    , OMB.DefaultOrganisation	AS	[Default]
    , ORG.OrganisationId
    , OTY.Name                AS  [OrganisationType]
    , CASE
		    WHEN UPR.CurrentOrganisationId = ORG.OrganisationId
			    THEN 1
			    ELSE 0
		    END
	    AS [Current]
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG		ON	ORG.OrganisationId			= OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress			OAD		ON	OAD.OrganisationId		  = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType				OTY		ON	OTY.OrganisationTypeId  = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisationRequest		MAR		ON  MAR.UserID				= UPR.UserID
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView3" runat="server" AllowSorting="True" caption="Current Organisation / Module Access" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource3">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpUserAccess')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpUserAccess	END

    SELECT DISTINCT
	  ORG.Name					  AS	[Organisation]
	  , MDL.StaticName		AS	[Module]
	  , MDROL.Name				AS	[Module Role]
	  , GLBROL.Name				AS	[Global Role]
    INTO #tmpUserAccess
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							      GLBROL	ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
    AND   OMB.Active = 1
	  AND		MDL.StaticName != 'PORTAL'
    AND		MDL.Active = 1
    AND   MAU.Active = 1
    AND   UPR.Email = @prmEmail

    SELECT DISTINCT
	  [Organisation]
	  , [Module]	
	  , STUFF((
		    SELECT ', ' + UA2.[Module Role]
		    FROM	#tmpUserAccess	UA2
		    WHERE	UA2.[Organisation]	= UA1.[Organisation]
		    AND		UA2.[Module]		    = UA1.[Module]
		    FOR XML PATH('') 
	      ), 1 ,1 , '')
	      AS [Module Role]
	    , [Global Role]
    FROM	#tmpUserAccess	UA1

	  UNION

	  SELECT DISTINCT
	  ORG.Name					  AS	[Organisation]
	  , MDL.StaticName		AS	[Module]
	  , CASE
			  WHEN OMB.Administrator = 1 THEN 'Administrator'
			  WHEN OMB.Administrator = 0 THEN 'User'
		  END
	  AS	[Module Role]
	  , GLBROL.Name				AS	[Global Role]
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							      GLBROL	ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
	  AND   OMB.Active = 1
	  AND		MDL.StaticName = 'PORTAL'
    AND		MDL.Active = 1
    AND   MAU.Active = 1
    AND   UPR.Email = @prmEmail
    ORDER BY [Organisation], [Module]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView20" runat="server" AllowSorting="True" caption="Organisation Access <u><i>Revoked</i></u>" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource20">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource20" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpUserRevoked')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpUserRevoked	END

	  SELECT DISTINCT
	  ORG.Name					        AS	[Organisation]
    , OMB.DefaultOrganisation	AS	[Default]
	  , MDL.StaticName		      AS	[Module]
	  , MDROL.Name				      AS	[Module Role]
	  INTO		#tmpUserRevoked
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    WHERE	ORG.Name IS NOT NULL 
    AND   OMB.Active = 0
    AND   UPR.Email  = @prmEmail

	  SELECT DISTINCT
	  [Organisation]
    , [Default]
	  , [Module]	
	  , STUFF((
		    SELECT ', ' + UR2.[Module Role]
		    FROM	#tmpUserRevoked	UR2
		    WHERE	UR2.[Organisation]	= UR1.[Organisation]
		    AND		UR2.[Module]		    = UR1.[Module]
		    FOR XML PATH('') 
	      ), 1 ,1 , '')
	      AS [Module Role]
    FROM	#tmpUserRevoked	UR1
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView24" runat="server" AllowSorting="True" caption="Module Access <u><i>Revoked</i></u>" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource24">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource24" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpModuleRevoked')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpModuleRevoked	END

    SELECT DISTINCT
	  ORG.Name					  AS	[Organisation]
	  , MDL.StaticName		AS	[Module]
	  , MDROL.Name				AS	[Module Role]
	  , GLBROL.Name				AS	[Global Role]
    INTO #tmpModuleRevoked
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							      GLBROL	ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
    AND   OMB.Active = 1
	  AND		MDL.StaticName != 'PORTAL'
    AND		MDL.Active = 1
    AND   MAU.Active = 0
    AND   UPR.Email = @prmEmail

    SELECT DISTINCT
	  [Organisation]
	  , [Module]	
	  , STUFF((
		    SELECT ', ' + MR2.[Module Role]
		    FROM	#tmpModuleRevoked	MR2
		    WHERE	MR2.[Organisation]	= MR1.[Organisation]
		    AND		MR2.[Module]		    = MR1.[Module]
		    FOR XML PATH('') 
	      ), 1 ,1 , '')
	      AS [Module Role]
	    , [Global Role]
    FROM	#tmpModuleRevoked	MR1

	  UNION

	  SELECT DISTINCT
	  ORG.Name					  AS	[Organisation]
	  , MDL.StaticName		AS	[Module]
	  , CASE
			  WHEN OMB.Administrator = 1 THEN 'Administrator'
			  WHEN OMB.Administrator = 0 THEN 'User'
		  END
	  AS	[Module Role]
	  , GLBROL.Name				AS	[Global Role]
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							      GLBROL	ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
	  AND   OMB.Active = 1
	  AND		MDL.StaticName = 'PORTAL'
    AND		MDL.Active = 1
    AND   MAU.Active = 0
    AND   UPR.Email = @prmEmail
    ORDER BY [Organisation], [Module]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  </div><!-- ./panel-body -->
</div><!-- ./panel-primary -->

<!-------------------------------------------------------------------------------------------------------------------------
------ Pending Organisation, Module and Password Requests
-------------------------------------------------------------------------------------------------------------------------->

<div class="panel panel-danger" id="divSeperatorPending" runat="server">
<div class="panel-heading"><h3 class="panel-title">Pending Organisation, Module and Password Requests</h3></div><!-- ./panel-heading -->
  <div class="panel-body">

  <asp:GridView ID="GridView9" runat="server" AllowSorting="True" caption="New Organisation <i>Creation</i> Request" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource9">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" />
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource9" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORQ.Name					    AS	[Organisation Requested]
	  , MDLRQ.StaticName		AS	[Module Requested]
	  , ORQ.RegistrationNo
	  , ORQ.RequestDate     AS  [Request Date]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.OrganisationMembershipRequest	ORMQ	ON	ORMQ.UserId						    = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORQN	ON	ORQN.OrganisationId				= ORMQ.OrganisationId
    LEFT JOIN	dbo.OrganisationModuleAuthorisationRequest	OMAR	ON	OMAR.UserID			= UPR.UserID
    LEFT JOIN	dbo.OrganisationRequest				    ORQ		ON	ORQ.OrganisationRequestId	= OMAR.OrganisationRequestId
    LEFT JOIN	dbo.Module				  			        MDLRQ	ON	MDLRQ.ModuleId					  = OMAR.ModuleId
	  WHERE ORQ.OrganisationRequestId	IS NOT NULL	
	  AND	ORQ.Active = 1
	  AND	UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView7" runat="server" AllowSorting="True" caption="Pending <i>Organisation</i> Access Requests"
      AutoGenerateColumns="False"
      showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource7" 
      onsorting="GridView7_Sorting">
  <Columns>
    <asp:BoundField DataField="Organisation Access Requested" HeaderText="Organisation Access Requested" SortExpression="Organisation Access Requested" >
    </asp:BoundField>
    <asp:BoundField DataField="Request Date" HeaderText="Request Date" SortExpression="Request Date" >
    </asp:BoundField>
    <asp:TemplateField HeaderText="Request Active" SortExpression="Request Active">
      <ItemTemplate>
      <asp:CheckBox ID="cbOrgDefault" Checked='<%# Convert.ToBoolean(Eval("Request Active")) %>' runat="server" Enabled="False" />
      </ItemTemplate>
    </asp:TemplateField>
    <asp:HyperLinkField 
      HeaderText="EDEN"
      Target="_blank"
      DataNavigateUrlFields="OrganisationId" 
      DataNavigateUrlFormatString="https://www.edenireland.ie/manage/organisation/{0}/members" 
      DataTextField="OrganisationId" 
      DataTextFormatString="EDEN Org Link" />  
    <asp:HyperLinkField 
      HeaderText="LEMA"
      Target="_blank"
      DataNavigateUrlFields="OrganisationId" 
      DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=1&id=%7b{0}%7d&pagetype=entityrecord"
      DataTextField="OrganisationId" 
      DataTextFormatString="LEMA Org Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>

  <asp:SqlDataSource ID="SqlDataSource7" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORQN.Name					  AS	[Organisation Access Requested]
	  , ORMQ.RequestDate  AS  [Request Date]
	  , ORMQ.Active       AS  [Request Active]
    , ORQN.OrganisationId
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.OrganisationMembershipRequest	ORMQ	ON	ORMQ.UserId						    = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORQN	ON	ORQN.OrganisationId				= ORMQ.OrganisationId
    WHERE	ORMQ.Active = 1
	  AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView22" runat="server" AllowSorting="True" caption="New Organisation Request - Temporary Organisation" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource22">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" />
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource22" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpOrg')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrg	END
    CREATE TABLE #tmpOrg
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrg
    SELECT 
	    TMPORG.CompanyName
	    , OTY.Name
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.OrganisationType						        OTY			ON	OTY.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.CompanyName		IS NOT NULL	 
    AND		TMPORG.Email = @prmEmail


    IF OBJECT_ID('Tempdb..#tmpOrgLANATPRVT')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrgLANATPRVT	END
    CREATE TABLE #tmpOrgLANATPRVT
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrgLANATPRVT
    SELECT 
	    CASE
		    WHEN TMPORG.CompanyId		    IS NOT NULL	THEN ORGPRVT.Name		
		    WHEN TMPORG.OrganisationId	IS NOT NULL	THEN ORGLANAT.Name				
		    END
	    AS	[Organisation]
	    , OTYLANAT.Name	
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.Organisation							          ORGLANAT	ON	ORGLANAT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYLANAT	ON	OTYLANAT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    LEFT JOIN	dbo.Organisation							          ORGPRVT		ON	ORGPRVT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYPRVT		ON	OTYPRVT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.Email = @prmEmail

    SELECT
    [Organisation]
    , [OrganisationType]
    , Email
    , RegistrationNo
    FROM	#tmpOrgLANATPRVT
    WHERE [Organisation] IS NOT NULL

    UNION

    SELECT
    Organisation
    , OrganisationType
    , Email
    , RegistrationNo
    FROM	#tmpOrg
    WHERE [Organisation] IS NOT NULL
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView23" runat="server" AllowSorting="True" caption="User Temporary Details" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource23">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" />
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource23" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
	    UserId
	    , Email
	    , FirstName
	    , LastName
	    , Phone
	    , Mobile
	    , IsRegistration
    FROM	[EdenIdentity-PRD].dbo.TempContactDetail
    WHERE	Email =  @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView8" runat="server" AllowSorting="True" caption="Pending <i>Module</i> Access Requests" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource8">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource8" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORG.Name					  AS	[Organsiation]
	  , MDRQ.StaticName		AS	[Module Access Requested]
	  , MAR.RequestDate   AS  [Request Date]
    , MAR.Active        AS  [Request Active]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.Organisation					        ORG	  ON	ORG.OrganisationId	= UPR.CurrentOrganisationId
    LEFT JOIN	dbo.ModuleAuthorisationRequest	  MAR	  ON  MAR.UserID					= UPR.UserID
    LEFT JOIN	dbo.Module				  			        MDRQ	ON	MDRQ.ModuleId				= MAR.ModuleId
    WHERE	MAR.Active = 1 
	  AND 	UPR.Email  = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView15" runat="server" AllowSorting="True" caption="Organisation Administrators <i>(Organisation Access Request)</i>" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource15">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource15" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="    
    SELECT DISTINCT
	  LTRIM(RTRIM(UPR.FirstName)) + ' ' + LTRIM(RTRIM(UPR.LastName)) AS	[Admin Name]
	  , ORG.Name			  AS	[Organisation]
	  , MDL.StaticName	AS	[Module]
	  , CASE
			  WHEN OMB.Administrator = 1 THEN 'Administrator'
		  END
	  AS	[Role]
	  , UMB.PasswordExpiration
	  , UPR.Active
	  , UPR.Email
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							        GLBROL ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
    AND   UPR.Active = 1
	  AND   OMB.Active = 1
	  AND	  OMB.Administrator = 1 
	  AND		MDL.StaticName = 'PORTAL'
    AND		MDL.Active = 1
    AND		ORG.Name	 IN 	
    (
      SELECT DISTINCT
	    ORQN.Name	AS	[Organisation Access Requested]
      FROM		  dbo.UserProfile						        UPR
      LEFT JOIN	dbo.OrganisationMembershipRequest	ORMQ	ON	ORMQ.UserId					= UPR.UserId
      LEFT JOIN	dbo.Organisation					        ORQN	ON	ORQN.OrganisationId	= ORMQ.OrganisationId
      WHERE	ORMQ.Active = 1
	    AND		UPR.Email   = @prmEmail
    )
    ORDER BY [Organisation], [Admin Name], [Module]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView16" runat="server" AllowSorting="True" caption="Administrators for <i>Module Access</i>" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource16">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource16" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    LTRIM(RTRIM(UPR.FirstName)) + ' ' + LTRIM(RTRIM(UPR.LastName)) AS	[Admin Name]
    , ORG.Name			  AS	[Organisation]
    , MDL.StaticName	AS	[Module]
    , MDROL.Name		  AS	[Role]
    , UMB.PasswordExpiration
    , UPR.Active
    , UPR.Email
    FROM		  dbo.UserProfile				        UPR
    LEFT JOIN	dbo.OrganisationMembership	  OMB		  ON  OMB.UserId			              = UPR.UserId
    LEFT JOIN	dbo.ModuleAuthorisation			  MAU		  ON	MAU.UserId						        = OMB.UserID
    LEFT JOIN	dbo.ModuleAuthorisationRole	  MAUROL	ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	  ON	MDROL.RoleId					        = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		  ON	MDL.ModuleId					        = MAU.ModuleId
    LEFT JOIN	dbo.Organisation			        ORG		  ON  ORG.OrganisationId	          = OMB.OrganisationId
    LEFT JOIN	dbo.UserMembership			      UMB		  ON  UMB.UserId			              = UPR.UserId
    WHERE	MDROL.Name = 'Administrator'
    AND   UPR.Active = 1
    AND   OMB.Active = 1
    AND		MDL.StaticName	IN
	  (
		  SELECT DISTINCT
		  MDRQ.StaticName
		  FROM		  dbo.UserProfile						        UPR
		  LEFT JOIN	dbo.Organisation					        ORG	  ON	ORG.OrganisationId	= UPR.CurrentOrganisationId
		  LEFT JOIN	dbo.ModuleAuthorisationRequest	  MAR	  ON  MAR.UserID					= UPR.UserID
		  LEFT JOIN	dbo.Module				  			        MDRQ	ON	MDRQ.ModuleId				= MAR.ModuleId
		  WHERE	MAR.Active  = 1 
		  AND 	UPR.Email   = @prmEmail
	  )
    AND		ORG.Name		IN 	
    (
      SELECT DISTINCT
	    ORG.Name	AS	[Organsiation]
      FROM		  dbo.UserProfile						        UPR
      LEFT JOIN	dbo.Organisation					        ORG	  ON	ORG.OrganisationId	= UPR.CurrentOrganisationId
      LEFT JOIN	dbo.ModuleAuthorisationRequest	  MAR	  ON  MAR.UserID					= UPR.UserID
      LEFT JOIN	dbo.Module				  			        MDRQ	ON	MDRQ.ModuleId				= MAR.ModuleId
      WHERE	MAR.Active = 1 
	    AND 	UPR.Email  = @prmEmail
    )
    
	  UNION

	  SELECT DISTINCT
	  LTRIM(RTRIM(UPR.FirstName)) + ' ' + LTRIM(RTRIM(UPR.LastName)) AS	[Admin Name]
	  , ORG.Name			  AS	[Organisation]
	  , MDL.StaticName	AS	[Module]
	  , CASE
			  WHEN OMB.Administrator = 1 THEN 'Administrator'
		  END
	  AS	[Role]
	  , UMB.PasswordExpiration
	  , UPR.Active
	  , UPR.Email
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							        GLBROL ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
    AND   UPR.Active = 1
	  AND   OMB.Active = 1
	  AND	  OMB.Administrator = 1 
	  AND		MDL.StaticName = 'PORTAL'
    AND		MDL.Active = 1
    AND		ORG.Name		IN 	
    (
      SELECT DISTINCT
	    ORG.Name	AS	[Organsiation]
      FROM		  dbo.UserProfile						        UPR
      LEFT JOIN	dbo.Organisation					        ORG	  ON	ORG.OrganisationId	= UPR.CurrentOrganisationId
      LEFT JOIN	dbo.ModuleAuthorisationRequest	  MAR	  ON  MAR.UserID					= UPR.UserID
      LEFT JOIN	dbo.Module				  			        MDRQ	ON	MDRQ.ModuleId				= MAR.ModuleId
      WHERE	MAR.Active = 1 
	    AND 	UPR.Email  = @prmEmail
    )
    ORDER BY [Organisation], [Admin Name], [Module]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  <asp:GridView ID="GridView11" runat="server" AllowSorting="True" caption="Password Reset Requests" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource11">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource11" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    EdenUserId  AS [Eden UserID]
    , Token     AS [Password Token]
    , CreatedOn AS [Created On]
    FROM [EdenIdentity-PRD].dbo.Password	
    WHERE Email = @prmEmail 
    ORDER BY CreatedOn DESC
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <div id="divTokens" runat="server">

  <!-------------------------------------------->
  <!-- Text Box For Account Verification Link -->
  <!-------------------------------------------->
    
  <div id="divVerificationLink" runat="server">
  Account verification link:  <br />
  <asp:textbox id="txtCopyVerificationLink" runat="server" width="1040px" height="32px" />

  <script type="text/javascript">
    var clipboard = new Clipboard('.btn');

    clipboard.on('success', function (e) {
      console.log(e);
    });

    clipboard.on('error', function (e) {
      console.log(e);
    });
  </script>
  <button id="btnCopyVerificationLink" class="btn" data-clipboard-action="copy" 
      data-clipboard-target="#txtCopyVerificationLink" alt="Copy" runat="server" title="Copy to clipboard">
    <i class="fa fa-clipboard" aria-hidden="true" ></i>
  </button>
  <br />
  </div>
  
  <!--------------------------------------->
  <!-- Text Box For Password Reset Token -->
  <!--------------------------------------->
  
  <div id="divPasswordReset" runat="server">
  Password reset link: <br />
  <asp:textbox id="txtCopyPasswordResetLink" runat="server" width="1040px" height="32px" />
   <script type="text/javascript">
     var clipboard = new Clipboard('.btn');

     clipboard.on('success', function (e) {
       console.log(e);
     });

     clipboard.on('error', function (e) {
       console.log(e);
     });
  </script>
  <button id="btnCopyPasswordResetLink" class="btn" data-clipboard-action="copy" 
      data-clipboard-target="#txtCopyPasswordResetLink" alt="Copy" runat="server" title="Copy to clipboard">
    <i class="fa fa-clipboard" aria-hidden="true" ></i>
  </button>
  <br />
  </div><!-- ./divPasswordReset -->
  
   
  
  <div id="divPasswordResetTokenExpiry" runat="server">
    <asp:Label id="lblPasswordResetTokenExpiry" runat="server"></asp:Label>
    <br />
  </div><!-- ./divPasswordResetTokenExpiry -->


  </div><!-- ./divTokens -->

  </div><!-- ./panel-body -->
</div><!-- ./panel-primary -->

<!-------------------------------------------------------------------------------------------------------------------------
------ Licence Access and Requests
-------------------------------------------------------------------------------------------------------------------------->

<div class="panel panel-primary" id="divSeperatorLicences" runat="server">
<div class="panel-heading"><h3 class="panel-title">Licence Access and Requests</h3></div><!-- ./panel-heading -->
  <div class="panel-body">  


  <asp:GridView ID="GridView2" runat="server" AllowSorting="True" caption="Current Licence Access"
    AllowPaging = "true" PageSize = "20" AutoGenerateColumns="False"
    CssClass="table table-paging table-striped table-nonfluid table-bordered table-hover" GridLines="None" 
     DataSourceID="SqlDataSource2" 
      onsorting="GridView2_Sorting">
    <Columns>
      <asp:BoundField DataField="Licence Code" HeaderText="Licence Code" SortExpression="Licence Code" >
      </asp:BoundField>
      <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Name" HeaderText="Licence Name" SortExpression="Licence Name" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Type" HeaderText="Licence Type" SortExpression="Licence Type" >
      </asp:BoundField>
      <asp:TemplateField HeaderText="Active" SortExpression="Active">
        <ItemTemplate>
        <asp:CheckBox ID="cbLicActive" Checked='<%# Convert.ToBoolean(Eval("Active")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
     <asp:HyperLinkField 
        HeaderText="EDEN"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="https://www.edenireland.ie/manage/licence/{0}/revokeapprove" 
        DataTextField="LicenceProfileId" 
        DataTextFormatString="EDEN Licence Link" />  
     <asp:HyperLinkField 
        HeaderText="LEMA"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=10434&extraqs=%3fetc%3d10434%26id%3d%257b{0}%257d%26pagemode%3diframe%26preloadcache%3d1473322917508&pagetype=entityrecord"
        DataTextField="LicenceProfileId" 
        DataTextFormatString="LEMA Licence Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>

  <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  LPRNM.LicenceCode			      AS	[Licence Code]
	  , ORG.Name					        AS	[Organisation]
	  , LPRNM.LicenceProfileName	AS	[Licence Name]
    , LPRNM.LicenceType         AS  [Licence Type]
	  , LPA.Active				        AS	[Active]
    , LPRNM.LicenceProfileId
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership			    UMB		ON	UMB.UserId						= UPR.UserId
    LEFT JOIN	dbo.LicenceProfileAccess	  LPA		ON	LPA.UserId						= UPR.UserId
    LEFT JOIN	dbo.LicenceProfile				  LPRNM	ON	LPA.LicenceProfileId	= LPRNM.LicenceProfileId
    LEFT JOIN	dbo.OrganisationMembership	OMB	  ON	OMB.UserId						= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG	  ON	(
																                    ORG.OrganisationId		= OMB.OrganisationId
															                      AND	
                                                    ORG.OrganisationId	  = LPRNM.OrganisationId
															                      )
    WHERE	ORG.Name IS NOT NULL
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
    

  <asp:GridView ID="GridView10" runat="server" AllowSorting="True" caption="<i>Pending</i> Licence Access Request"
    AllowPaging = "true" PageSize = "20" AutoGenerateColumns="False"
    CssClass="table table-paging table-striped table-nonfluid table-bordered table-hover" GridLines="None"  
     DataSourceID="SqlDataSource10" 
      onsorting="GridView10_Sorting">
    <Columns>
      <asp:BoundField DataField="Licence Code" HeaderText="Licence Code" SortExpression="Licence Code" >
      </asp:BoundField>
      <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Requested" HeaderText="Licence Requested" SortExpression="Licence Requested" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Type" HeaderText="Licence Type" SortExpression="Licence Type" >
      </asp:BoundField>
      <asp:BoundField DataField="Request Date" HeaderText="Request Date" SortExpression="Request Date" >
      </asp:BoundField>
      <asp:TemplateField HeaderText="Request Active" SortExpression="Request Active">
        <ItemTemplate>
        <asp:CheckBox ID="cbLicReqActive" Checked='<%# Convert.ToBoolean(Eval("Request Active")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
     <asp:HyperLinkField 
        HeaderText="EDEN"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="https://www.edenireland.ie/manage/licence/{0}/revokeapprove" 
        DataTextField="LicenceProfileId" 
        DataTextFormatString="EDEN Licence Link" />  
     <asp:HyperLinkField 
        HeaderText="LEMA"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=10434&extraqs=%3fetc%3d10434%26id%3d%257b{0}%257d%26pagemode%3diframe%26preloadcache%3d1473322917508&pagetype=entityrecord"
        DataTextField="LicenceProfileId" 
        DataTextFormatString="LEMA Licence Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>

  <asp:SqlDataSource ID="SqlDataSource10" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand=
    "SELECT DISTINCT
	  LPRQNM.LicenceCode		      AS	[Licence Code]
	  , ORG.Name					        AS	[Organisation]
	  , LPRQNM.LicenceProfileName	AS	[Licence Requested]
    , LPRQNM.LicenceType        AS  [Licence Type]
    , LPREQ.RequestDate         AS  [Request Date]
	  , LPREQ.Active				      AS	[Request Active]
    , LPRQNM.LicenceProfileId
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.LicenceProfileAccessRequest		LPREQ	  ON	LPREQ.UserId					  = UPR.UserId
    LEFT JOIN	dbo.LicenceProfile					      LPRQNM	ON	LPRQNM.LicenceProfileId	= LPREQ.LicenceProfileId
    LEFT JOIN	dbo.OrganisationMembership			  OMB		  ON	OMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORG		  ON	(
															                              ORG.OrganisationId			= OMB.OrganisationId
															                              AND	
															                              ORG.OrganisationId			= LPRQNM.OrganisationId
															                              )
    WHERE	ORG.Name IS NOT NULL
    AND   LPREQ.Active = 1
    AND		UPR.Email =  @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  
  <asp:GridView ID="GridView18" runat="server" AllowSorting="True" caption="Available Licences"
    AllowPaging = "true" PageSize = "20" AutoGenerateColumns="False"
    CssClass="table table-paging table-striped table-nonfluid table-bordered table-hover" GridLines="None" 
     DataSourceID="SqlDataSource18" 
      onsorting="GridView18_Sorting">
    <Columns>
      <asp:BoundField DataField="Licence Code" HeaderText="Licence Code" SortExpression="Licence Code" >
      </asp:BoundField>
      <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Name" HeaderText="Licence Name" SortExpression="Licence Name" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Type" HeaderText="Licence Type" SortExpression="Licence Type" >
      </asp:BoundField>
      <asp:TemplateField HeaderText="Active" SortExpression="Active">
        <ItemTemplate>
        <asp:CheckBox ID="cbLicActive" Checked='<%# Convert.ToBoolean(Eval("Active")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
     <asp:HyperLinkField 
        HeaderText="EDEN"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="https://www.edenireland.ie/manage/licence/{0}/revokeapprove" 
        DataTextField="LicenceProfileId" 
        DataTextFormatString="EDEN Licence Link" />  
     <asp:HyperLinkField 
        HeaderText="LEMA"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=10434&extraqs=%3fetc%3d10434%26id%3d%257b{0}%257d%26pagemode%3diframe%26preloadcache%3d1473322917508&pagetype=entityrecord"
        DataTextField="LicenceProfileId" 
        DataTextFormatString="LEMA Licence Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>


  <asp:SqlDataSource ID="SqlDataSource18" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  LPR.LicenceCode           AS  [Licence Code]
	  , ORG.Name					      AS	[Organisation]
	  , LPR.LicenceProfileName  AS  [Licence Name]
	  , LPR.LicenceType         AS  [Licence Type]
	  , LPR.Active
    , LPR.LicenceProfileId
    FROM		  dbo.UserProfile				      UPR  
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId			    = UPR.UserId
    LEFT JOIN	dbo.Organisation			      ORG		ON	ORG.OrganisationId	= OMB.OrganisationId
    LEFT JOIN	dbo.LicenceProfile			    LPR		ON	LPR.OrganisationId	= ORG.OrganisationId
    WHERE		LPR.Active = 1
    AND			UPR.Email  = @prmEmail
    AND			LPR.LicenceCode	NOT IN
	  (
	    SELECT DISTINCT
	    LPRNM.LicenceCode
      FROM		  dbo.UserProfile						  UPR
      LEFT JOIN	dbo.UserMembership			    UMB		ON	UMB.UserId						= UPR.UserId
      LEFT JOIN	dbo.LicenceProfileAccess	  LPA		ON	LPA.UserId						= UPR.UserId
      LEFT JOIN	dbo.LicenceProfile				  LPRNM	ON	LPA.LicenceProfileId	= LPRNM.LicenceProfileId
      LEFT JOIN	dbo.OrganisationMembership	OMB	  ON	OMB.UserId						= UPR.UserId
      LEFT JOIN	dbo.Organisation					  ORG	  ON	(
																                      ORG.OrganisationId		= OMB.OrganisationId
															                        AND	
                                                      ORG.OrganisationId	  = LPRNM.OrganisationId
															                        )
      WHERE	ORG.Name IS NOT NULL
      AND		UPR.Email = @prmEmail
	  )
    ORDER BY [Organisation], [Licence Code]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  
  <asp:GridView ID="GridView19" runat="server" AllowSorting="True" caption="Potentially Available Licences <i>(If Organisation Access Approved)</i>"
    AllowPaging = "true" PageSize = "20" AutoGenerateColumns="False"
    CssClass="table table-paging table-striped table-nonfluid table-bordered table-hover" GridLines="None" 
     DataSourceID="SqlDataSource19" 
      onsorting="GridView19_Sorting">
    <Columns>
      <asp:BoundField DataField="Licence Code" HeaderText="Licence Code" SortExpression="Licence Code" >
      </asp:BoundField>
      <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Name" HeaderText="Licence Name" SortExpression="Licence Name" >
      </asp:BoundField>
      <asp:BoundField DataField="Licence Type" HeaderText="Licence Type" SortExpression="Licence Type" >
      </asp:BoundField>
      <asp:TemplateField HeaderText="Active" SortExpression="Active">
        <ItemTemplate>
        <asp:CheckBox ID="cbLicActive" Checked='<%# Convert.ToBoolean(Eval("Active")) %>' runat="server" Enabled="False" />
        </ItemTemplate>
      </asp:TemplateField>
     <asp:HyperLinkField 
        HeaderText="EDEN"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="https://www.edenireland.ie/manage/licence/{0}/revokeapprove" 
        DataTextField="LicenceProfileId" 
        DataTextFormatString="EDEN Licence Link" />  
     <asp:HyperLinkField 
        HeaderText="LEMA"
        Target="_blank"
        DataNavigateUrlFields="LicenceProfileId" 
        DataNavigateUrlFormatString="http://wexcrmapp:5544/EPA/main.aspx?etc=10434&extraqs=%3fetc%3d10434%26id%3d%257b{0}%257d%26pagemode%3diframe%26preloadcache%3d1473322917508&pagetype=entityrecord"
        DataTextField="LicenceProfileId" 
        DataTextFormatString="LEMA Licence Link" />   
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>


  <asp:SqlDataSource ID="SqlDataSource19" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  LPR.LicenceCode           AS  [Licence Code]
	  , ORG.Name					      AS	[Organisation]
	  , LPR.LicenceProfileName  AS  [Licence Name]
	  , LPR.LicenceType         AS  [Licence Type]
	  , LPR.Active
    , LPR.LicenceProfileId
    FROM		  dbo.UserProfile				            UPR  
    LEFT JOIN	dbo.OrganisationMembershipRequest	OMBR  ON	OMBR.UserId			    = UPR.UserId
    LEFT JOIN	dbo.Organisation			            ORG		ON	ORG.OrganisationId	= OMBR.OrganisationId
    LEFT JOIN	dbo.LicenceProfile			          LPR		ON	LPR.OrganisationId	= OMBR.OrganisationId
    WHERE		LPR.Active	= 1
    AND			OMBR.Active	= 1
    AND			UPR.Email = @prmEmail
    ORDER BY [Organisation], [Licence Code]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  
  <asp:GridView ID="GridView17" runat="server" AllowSorting="True" caption="Administrators for <i>Licence Access</i>" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource17">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
    <footerstyle backcolor="white" forecolor="white" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource17" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    LTRIM(RTRIM(UPR.FirstName)) + ' ' + LTRIM(RTRIM(UPR.LastName)) AS	[Admin Name]
    , ORG.Name			  AS	[Organisation]
    , MDL.StaticName	AS	[Module]
    , MDROL.Name		  AS	[Role]
    , UMB.PasswordExpiration
    , UPR.Active
    , UPR.Email
    FROM		  dbo.UserProfile				        UPR
    LEFT JOIN	dbo.OrganisationMembership	  OMB		  ON  OMB.UserId			              = UPR.UserId
    LEFT JOIN	dbo.ModuleAuthorisation			  MAU		  ON	MAU.UserId						        = OMB.UserID
    LEFT JOIN	dbo.ModuleAuthorisationRole	  MAUROL	ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	  ON	MDROL.RoleId					        = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		  ON	MDL.ModuleId					        = MAU.ModuleId
    LEFT JOIN	dbo.Organisation			        ORG		  ON  ORG.OrganisationId	          = OMB.OrganisationId
    LEFT JOIN	dbo.UserMembership			      UMB		  ON  UMB.UserId			              = UPR.UserId
    WHERE	MDROL.Name = 'Administrator'
    AND   UPR.Active = 1
    AND   OMB.Active = 1
    AND		MDL.StaticName	= 'AM'
    AND		ORG.Name		IN 	
    (
      SELECT DISTINCT
	    ORG.Name					        AS	[Organisation]
      FROM		  dbo.UserProfile						        UPR
      LEFT JOIN	dbo.LicenceProfileAccessRequest		LPREQ	  ON	LPREQ.UserId					  = UPR.UserId
      LEFT JOIN	dbo.LicenceProfile					      LPRQNM	ON	LPRQNM.LicenceProfileId	= LPREQ.LicenceProfileId
      LEFT JOIN	dbo.OrganisationMembership			  OMB		  ON	OMB.UserId						  = UPR.UserId
      LEFT JOIN	dbo.Organisation					        ORG		  ON	(
															                                    ORG.OrganisationId	= OMB.OrganisationId
															                                AND ORG.OrganisationId	= LPRQNM.OrganisationId
															                                )
      WHERE	ORG.Name IS NOT NULL
      AND   LPREQ.Active  = 1
      AND		UPR.Email     = @prmEmail
    )
    
	  UNION

	  SELECT DISTINCT
	  LTRIM(RTRIM(UPR.FirstName)) + ' ' + LTRIM(RTRIM(UPR.LastName)) AS	[Admin Name]
	  , ORG.Name			  AS	[Organisation]
	  , MDL.StaticName	AS	[Module]
	  , CASE
			  WHEN OMB.Administrator = 1 THEN 'Administrator'
		  END
	  AS	[Role]
	  , UMB.PasswordExpiration
	  , UPR.Active
	  , UPR.Email
    FROM		  dbo.UserProfile					      UPR
    LEFT JOIN	dbo.UserMembership					  UMB		 ON	UMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership		OMB		 ON	OMB.UserId						 = UPR.UserId
    LEFT JOIN	dbo.Organisation					    ORG		 ON	ORG.OrganisationId		 = OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress		    OAD		 ON	OAD.OrganisationId		 = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType			    OTY		 ON	OTY.OrganisationTypeId = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisation		    MAU		 ON (
														    		                      MAU.UserId				 = OMB.UserID
												    		                      AND MAU.OrganisationId = OMB.OrganisationId
                        															)
    LEFT JOIN	dbo.ModuleAuthorisationRole		MAUROL ON	MAUROL.ModuleAuthorisationId	= MAU.ModuleAuthorisationId
    LEFT JOIN	dbo.Role							        MDROL	 ON	MDROL.RoleId					 = MAUROL.RoleId
    LEFT JOIN	dbo.Module				  			    MDL		 ON	MDL.ModuleId					 = MAU.ModuleId
    LEFT JOIN	dbo.GlobalModuleAuthorisation	GMA		 ON (
														                              GMA.ModuleId	     = MDL.ModuleId
														                          AND GMA.UserId	       = UPR.UserId
													                            )
    LEFT JOIN	dbo.Role							        GLBROL ON	GLBROL.RoleId					 = GMA.RoleId
    WHERE	ORG.Name IS NOT NULL 
    AND   UPR.Active = 1
    AND		MDL.Active = 1
	  AND   OMB.Active = 1
	  AND	  OMB.Administrator = 1 
	  AND		MDL.StaticName = 'PORTAL'
    AND		ORG.Name		IN 	
    (
      SELECT DISTINCT
	    ORG.Name					        AS	[Organisation]
      FROM		  dbo.UserProfile						        UPR
      LEFT JOIN	dbo.LicenceProfileAccessRequest		LPREQ	  ON	LPREQ.UserId					  = UPR.UserId
      LEFT JOIN	dbo.LicenceProfile					      LPRQNM	ON	LPRQNM.LicenceProfileId	= LPREQ.LicenceProfileId
      LEFT JOIN	dbo.OrganisationMembership			  OMB		  ON	OMB.UserId						  = UPR.UserId
      LEFT JOIN	dbo.Organisation					        ORG		  ON	(
															                                    ORG.OrganisationId	= OMB.OrganisationId
															                                AND ORG.OrganisationId	= LPRQNM.OrganisationId
															                                )
      WHERE	ORG.Name IS NOT NULL
      AND   LPREQ.Active  = 1
      AND		UPR.Email     = @prmEmail
    )
    ORDER BY [Organisation], [Admin Name], [Module]
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  </div><!-- ./panel-body -->
</div><!-- ./panel-primary -->

<!-------------------------------------------------------------------------------------------------------------------------
------ User ID and Notifications
-------------------------------------------------------------------------------------------------------------------------->

<div class="panel panel-primary" id="divSeperatorTokens" runat="server">
<div class="panel-heading"><h3 class="panel-title">User ID and Notifications</h3></div><!-- ./panel-heading -->
  <div class="panel-body">
  

  <asp:GridView ID="GridView13" runat="server" AllowSorting="True" caption="Notifications"
    AllowPaging = "true" PageSize = "10" AutoGenerateColumns="False"
    CssClass="table table-paging table-striped table-bordered table-hover" GridLines="None" 
     DataSourceID="SqlDataSource13" 
     EnableSortingAndPagingCallbacks="True"
      onsorting="GridView13_Sorting">
    <Columns>      
      <asp:BoundField DataField="NotificationBody" HeaderText="Notification Body" SortExpression="NotificationBody" HtmlEncode="false" >
        <ItemStyle Width="36%"></ItemStyle>
      </asp:BoundField>       
      <asp:BoundField DataField="EmailSentOn" HeaderText="Email Sent" SortExpression="EmailSentOn" >
        <ItemStyle Width="12%"></ItemStyle>
      </asp:BoundField>
      <asp:BoundField DataField="DateRead" HeaderText="Date Read" SortExpression="DateRead" >
        <ItemStyle Width="12%"></ItemStyle>
      </asp:BoundField>
      <asp:BoundField DataField="NotificationDefinition" HeaderText="Notification Definition" SortExpression="NotificationDefinition" >
        <ItemStyle Width="20%"></ItemStyle>
      </asp:BoundField>
      <asp:BoundField DataField="EventType" HeaderText="Event Type" SortExpression="EventType" >
        <ItemStyle Width="20%"></ItemStyle>
      </asp:BoundField>
    </Columns>
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>



  <asp:SqlDataSource ID="SqlDataSource13" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  NOTF.Data		        AS	[NotificationBody]
	  , NOTF.EmailSentOn
	  , NOTF.DateRead
	  , NTDF.Name		      AS	[NotificationDefinition]
	  , EVT.Name		      AS	[EventType]
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.Notification					  NOTF	ON	NOTF.AddresseeUserId			    = UPR.UserId
    LEFT JOIN	dbo.NotificationDefinition	NTDF	ON  NTDF.NotificationDefinitionId	= NOTF.NotificationDefinition
    LEFT JOIN	dbo.EventType						    EVT		ON  EVT.EventTypeId					      = NTDF.EventTypeId
    WHERE	UPR.Email = @prmEmail 
    ORDER BY EmailSentOn DESC
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView6" runat="server" AllowSorting="True" caption="TABLE: [EdenIdentity-PRD].dbo.[User]" 
    showfooter="false" CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource6">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource6" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT 
    Id
    , Email
    , Username
    , Token
    , CreatedOn
    , UniqueId 
    FROM [EdenIdentity-PRD].dbo.[User] 
    WHERE	Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView5" runat="server"  ShowHeader="False" caption="User ID - [EdenIdentity-PRD]" 
    CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource5">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource5" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UniqueId 
    FROM [EdenIdentity-PRD].dbo.[User] 
    WHERE	Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView14" runat="server"  ShowHeader="False" caption="User ID - [EdenSSO-PRD]" 
    CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource14">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource14" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UserId
    FROM [EdenSSO-PRD].[dbo].[UserProfile]
    WHERE Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView4" runat="server" ShowHeader="False" caption="User Identity Token" 
    CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource4">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpUserToken')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpUserToken	END

    SELECT 
    Token 
    INTO #tmpUserToken 
    FROM [EdenIdentity-PRD].dbo.[User] 
    WHERE Email = @prmEmail 
    ORDER BY CreatedOn DESC

    SELECT TOP (1)
    Token
    FROM #tmpUserToken
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="GridView12" runat="server" ShowHeader="False" caption="Password Reset Token" 
    CssClass="table table-curved table-hover table-striped" GridLines="None" DataSourceID="SqlDataSource12">
    <SortedAscendingHeaderStyle CssClass="sortasc" />
    <SortedDescendingHeaderStyle CssClass="sortdesc" /> 
  </asp:GridView>
  <asp:SqlDataSource ID="SqlDataSource12" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpPasswordToken') IS NOT NULL
	    BEGIN	DROP TABLE #tmpPasswordToken	END

    SELECT 
    Token 
    INTO #tmpPasswordToken 
    FROM [EdenIdentity-PRD].dbo.[Password] 
    WHERE Email = @prmEmail 
    ORDER BY CreatedOn DESC

    SELECT TOP (1) 
    Token 
    FROM #tmpPasswordToken
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  </div><!-- ./panel-body -->
</div><!-- ./panel-primary -->


<!-------------------------------------------------------------------------------------------------------------------------
------ SQL Queries - No Gridview - For Logic Checks
-------------------------------------------------------------------------------------------------------------------------->


  <!-- Check to see if user has a temporary organisation  -->
  <asp:SqlDataSource ID="SqlDataSource110" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpOrg')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrg	END
    CREATE TABLE #tmpOrg
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrg
    SELECT 
	    TMPORG.CompanyName
	    , OTY.Name
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.OrganisationType						        OTY			ON	OTY.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.CompanyName		IS NOT NULL	 
    AND		TMPORG.Email = @prmEmail


    IF OBJECT_ID('Tempdb..#tmpOrgLANATPRVT')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrgLANATPRVT	END
    CREATE TABLE #tmpOrgLANATPRVT
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrgLANATPRVT
    SELECT 
	    CASE
		    WHEN TMPORG.CompanyId		    IS NOT NULL	THEN ORGPRVT.Name		
		    WHEN TMPORG.OrganisationId	IS NOT NULL	THEN ORGLANAT.Name				
		    END
	    AS	[Organisation]
	    , OTYLANAT.Name	
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.Organisation							          ORGLANAT	ON	ORGLANAT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYLANAT	ON	OTYLANAT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    LEFT JOIN	dbo.Organisation							          ORGPRVT		ON	ORGPRVT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYPRVT		ON	OTYPRVT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.Email = @prmEmail

    SELECT
    [Organisation]
    FROM	#tmpOrgLANATPRVT
    WHERE [Organisation] IS NOT NULL

    UNION

    SELECT
    Organisation
    FROM	#tmpOrg
    WHERE [Organisation] IS NOT NULL
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>


  <!-- Check to see if user has a temporary organisation  -->
  <asp:SqlDataSource ID="SqlDataSource118" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpOrg')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrg	END
    CREATE TABLE #tmpOrg
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , CompanyId		      VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrg
    SELECT 
	    TMPORG.CompanyName
	    , OTY.Name
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
		, TMPORG.CompanyId
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.OrganisationType						        OTY			ON	OTY.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.CompanyName		IS NOT NULL	 
    AND		TMPORG.Email = @prmEmail


    IF OBJECT_ID('Tempdb..#tmpOrgLANATPRVT')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrgLANATPRVT	END
    CREATE TABLE #tmpOrgLANATPRVT
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , CompanyId		      VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrgLANATPRVT
    SELECT 
	    CASE
		    WHEN TMPORG.CompanyId		    IS NOT NULL	THEN ORGPRVT.Name		
		    WHEN TMPORG.OrganisationId	IS NOT NULL	THEN ORGLANAT.Name				
		    END
	    AS	[Organisation]
	    , OTYLANAT.Name	
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
		, TMPORG.CompanyId
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.Organisation							          ORGLANAT	ON	ORGLANAT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYLANAT	ON	OTYLANAT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    LEFT JOIN	dbo.Organisation							          ORGPRVT		ON	ORGPRVT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYPRVT		ON	OTYPRVT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.Email = @prmEmail

    SELECT
    CompanyId
    FROM	#tmpOrgLANATPRVT

    UNION

    SELECT
    CompanyID
    FROM	#tmpOrg
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>


  <!-- Check to see if user has a temporary organisation  -->
  <asp:SqlDataSource ID="SqlDataSource124" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    IF OBJECT_ID('Tempdb..#tmpOrg')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrg	END
    CREATE TABLE #tmpOrg
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , CompanyId		      VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrg
    SELECT 
	    TMPORG.CompanyName
	    , OTY.Name AS [OrganisationName]
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
		, TMPORG.CompanyId
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.OrganisationType						        OTY			ON	OTY.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.CompanyName		IS NOT NULL	 
    AND		TMPORG.Email = @prmEmail


    IF OBJECT_ID('Tempdb..#tmpOrgLANATPRVT')	IS NOT NULL
	    BEGIN	DROP TABLE #tmpOrgLANATPRVT	END
    CREATE TABLE #tmpOrgLANATPRVT
    (
      Organisation			  VARCHAR(MAX) COLLATE Latin1_General_CI_AS 
      , OrganisationType	VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , Email				      VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , RegistrationNo		VARCHAR(100) COLLATE Latin1_General_CI_AS 
      , CompanyId		      VARCHAR(100) COLLATE Latin1_General_CI_AS 
    )
    INSERT INTO #tmpOrgLANATPRVT
    SELECT 
	    CASE
		    WHEN TMPORG.CompanyId		    IS NOT NULL	THEN ORGPRVT.Name		
		    WHEN TMPORG.OrganisationId	IS NOT NULL	THEN ORGLANAT.Name				
		    END
	    AS	[Organisation]
	    , OTYLANAT.Name	AS [OrganisationName]
	    , TMPORG.Email
	    , TMPORG.RegistrationNo
		, TMPORG.CompanyId
    FROM		[EdenIdentity-PRD].dbo.TempOrganisation		TMPORG
    LEFT JOIN	dbo.Organisation							          ORGLANAT	ON	ORGLANAT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYLANAT	ON	OTYLANAT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    LEFT JOIN	dbo.Organisation							          ORGPRVT		ON	ORGPRVT.OrganisationId		  = TMPORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType						        OTYPRVT		ON	OTYPRVT.OrganisationTypeId	= TMPORG.OrganisationTypeId
    WHERE	TMPORG.Email = @prmEmail

	  DECLARE @orgid_tmpOrgLANATPRVT	NVARCHAR(MAX)
	  DECLARE @orgid_tmpOrg			NVARCHAR(MAX)
	
	  SET @orgid_tmpOrgLANATPRVT = (
		  SELECT
		  CompanyId
		  FROM	#tmpOrgLANATPRVT
			  WHERE EXISTS (    
			  SELECT
			  CompanyId
			  FROM	#tmpOrgLANATPRVT
			  )
	  )
	
	  SET @orgid_tmpOrg = (
		  SELECT
		  CompanyId
		  FROM	#tmpOrg
			  WHERE EXISTS (    
			  SELECT
			  CompanyId
			  FROM	#tmpOrg
			  )
	  )	
	
	  SELECT	[Name]
	  FROM	[EdenSSO-PRD].[dbo].[Organisation]
	  WHERE	[OrganisationId] = @orgid_tmpOrgLANATPRVT
	
	  UNION

	  SELECT	[Name]
	  FROM	[EdenSSO-PRD].[dbo].[Organisation]
	  WHERE	[OrganisationId] = @orgid_tmpOrg
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>


  <!-- Check to see if user is a member of an organisation - OrganisationID returned == True -->
  <asp:SqlDataSource ID="SqlDataSource111" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    ORG.OrganisationId    
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG		ON	ORG.OrganisationId			= OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress			OAD		ON	OAD.OrganisationId		  = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType				OTY		ON	OTY.OrganisationTypeId  = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisationRequest		MAR		ON  MAR.UserID				= UPR.UserID
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>



  <!-- Organisation requested name to display list of Org admins -->
  <asp:SqlDataSource ID="SqlDataSource112" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORQN.Name					  AS	[Organisation Access Requested]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.OrganisationMembershipRequest	ORMQ	ON	ORMQ.UserId						    = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORQN	ON	ORQN.OrganisationId				= ORMQ.OrganisationId
    WHERE	ORMQ.Active = 1
	  AND		UPR.Email   = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>  


  
  <!-- Organisation name of Module access requested to display list of Org admins -->
  <asp:SqlDataSource ID="SqlDataSource113" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORG.Name	AS	[Organsiation]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.Organisation					        ORG	  ON	ORG.OrganisationId	= UPR.CurrentOrganisationId
    LEFT JOIN	dbo.ModuleAuthorisationRequest	  MAR	  ON  MAR.UserID					= UPR.UserID
    LEFT JOIN	dbo.Module				  			        MDRQ	ON	MDRQ.ModuleId				= MAR.ModuleId
    WHERE	MAR.Active = 1 
	  AND 	UPR.Email  = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>



  <!-- Organisation name of Licence access requested to display list of Org admins -->
  <asp:SqlDataSource ID="SqlDataSource114" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORG.Name					        AS	[Organisation]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.LicenceProfileAccessRequest		LPREQ	  ON	LPREQ.UserId					  = UPR.UserId
    LEFT JOIN	dbo.LicenceProfile					      LPRQNM	ON	LPRQNM.LicenceProfileId	= LPREQ.LicenceProfileId
    LEFT JOIN	dbo.OrganisationMembership			  OMB		  ON	OMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORG		  ON	(
															                              ORG.OrganisationId			= OMB.OrganisationId
															                              AND	
															                              ORG.OrganisationId			= LPRQNM.OrganisationId
															                              )
    WHERE	ORG.Name IS NOT NULL
    AND   LPREQ.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>  

  <!-- User ID from Organisation Membership active status -->
  <asp:SqlDataSource ID="SqlDataSource115" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    OMB.UserId
    FROM      dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG		ON	ORG.OrganisationId			= OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress			OAD		ON	OAD.OrganisationId		  = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType				OTY		ON	OTY.OrganisationTypeId  = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisationRequest		MAR		ON  MAR.UserID				= UPR.UserID
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <!-- Password expiration date -->
  <asp:SqlDataSource ID="SqlDataSource116" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UMB.PasswordExpiration AS	[Password Expiration]
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <!-- Password token generation date -->
  <asp:SqlDataSource ID="SqlDataSource122" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    CreatedOn AS [Password Token Created On]
    FROM [EdenIdentity-PRD].dbo.Password	
    WHERE Email = @prmEmail 
    ORDER BY CreatedOn DESC
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <!-- User registration date -->
  <asp:SqlDataSource ID="SqlDataSource121" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    CreatedOn
    FROM  [EdenIdentity-PRD].dbo.[User]
    WHERE	Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  <asp:SqlDataSource ID="SqlDataSource117" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
	    UserId
    FROM	[EdenIdentity-PRD].dbo.TempContactDetail
    WHERE	Email =  @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  <asp:SqlDataSource ID="SqlDataSource119" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT
	  ORQ.Name					    AS	[Organisation Requested]
    FROM		  dbo.UserProfile						        UPR
    LEFT JOIN	dbo.OrganisationMembershipRequest	ORMQ	ON	ORMQ.UserId						    = UPR.UserId
    LEFT JOIN	dbo.Organisation					        ORQN	ON	ORQN.OrganisationId				= ORMQ.OrganisationId
    LEFT JOIN	dbo.OrganisationModuleAuthorisationRequest	OMAR	ON	OMAR.UserID			= UPR.UserID
    LEFT JOIN	dbo.OrganisationRequest				    ORQ		ON	ORQ.OrganisationRequestId	= OMAR.OrganisationRequestId
    LEFT JOIN	dbo.Module				  			        MDLRQ	ON	MDLRQ.ModuleId					  = OMAR.ModuleId
	  WHERE ORQ.OrganisationRequestId	IS NOT NULL	
	  AND	ORQ.Active = 1
	  AND	UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  <asp:SqlDataSource ID="SqlDataSource120" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UPM.UserId
    FROM		  dbo.UserProfile				      UPR
    LEFT JOIN	dbo.UserProviderMembership	UPM	ON UPM.UserId	= UPR.UserId
    WHERE UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>
  
  <asp:SqlDataSource ID="SqlDataSource123" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="    
    SELECT DISTINCT
	  EVT.Name		      AS	[EventType]
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.Notification					  NOTF	ON	NOTF.AddresseeUserId			    = UPR.UserId
    LEFT JOIN	dbo.NotificationDefinition	NTDF	ON  NTDF.NotificationDefinitionId	= NOTF.NotificationDefinition
    LEFT JOIN	dbo.EventType						    EVT		ON  EVT.EventTypeId					      = NTDF.EventTypeId
    WHERE	UPR.Email = @prmEmail 
    AND   EVT.Name LIKE '%Rejected%'
    ORDER BY EVT.Name	DESC
    ">
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource126" runat="server" 
    ConnectionString="<%$ ConnectionStrings:EdenSSO-PRDConnectionString %>" 
    EnableCaching="False"
    SelectCommand="
    SELECT DISTINCT 
    UMB.PasswordChangedDate AS	[Password Changed Date]
    FROM		  dbo.UserProfile						  UPR
    LEFT JOIN	dbo.UserMembership					UMB		ON	UMB.UserId						  = UPR.UserId
    LEFT JOIN	dbo.OrganisationMembership	OMB		ON	OMB.UserId					  	= UPR.UserId
    LEFT JOIN	dbo.Organisation					  ORG		ON	ORG.OrganisationId			= OMB.OrganisationId
    LEFT JOIN	dbo.OrganisationAddress			OAD		ON	OAD.OrganisationId		  = ORG.OrganisationId
    LEFT JOIN	dbo.OrganisationType				OTY		ON	OTY.OrganisationTypeId  = ORG.OrganisationTypeId
    LEFT JOIN	dbo.ModuleAuthorisationRequest		MAR		ON  MAR.UserID				= UPR.UserID
    WHERE	OMB.Active = 1
    AND		UPR.Email = @prmEmail
    ">    
    <SelectParameters>
      <asp:ControlParameter name="prmEmail" controlid="txtEmail" propertyname="Text" />
    </SelectParameters>
  </asp:SqlDataSource>


<!-------------------------------------------------------------------------------------------------------------------------
------ END: SQL Queries - No Gridview - For Logic Checks
-------------------------------------------------------------------------------------------------------------------------->

    <!--
    <div id="divTestVariables" style="color:#000000">
      strUserID_ID: <% =strUserID_ID %> <br />
      strUserID_SSO: <% =strUserID_SSO %> <br />
      strUserID_TempID: <% =strUserID_TempID %> <br />
      strUserID_UPM: <% =strUserID_UPM%> <br />
      strOrgID: <% =strOrgID %>  <br />
      strOrgTemp: <% =strOrgTemp %> <br />
      strOrgTempID: <% =strOrgTempID %> <br />
      strTokenUser: <% =strTokenUser%>  <br />
      strTokenPass: <% =strTokenPass %>  <br />
      strOrgAccessRequested: <% =strOrgAccessRequested %>  <br />
      strOrgModAccessRequested: <% =strOrgModAccessRequested %>  <br />
      strOrgLicAccessRequested: <% =strOrgLicAccessRequested %>  <br />
      strOrgMembershipUserID: <% =strOrgMembershipUserID %>  <br />
      strOrganisationRequest: <% =strOrganisationRequest%>  <br />

      strEventTypeRejected: <% =strEventTypeRejected%>  <br />

      dtDateUserPasswordExpiry: <% =dtDateUserPasswordExpiry %> <br />
      dtDateToday: <% =dtDateToday %> <br />
      DateTime.Now: <% =DateTime.Now %> <br />
  
      Now-24: <% =DateTime.Now.AddHours(-24) %> <br />
      dtDateRegistered: <% =dtDateRegistered %> <br />
      Reg+24: <% =dtDateRegistered.AddHours(+24) %> <br />
      tsDateRegistrationValidTimeRemaining: <% =tsDateRegistrationValidTimeRemaining %> <br />
      tsDateRegistrationValidTimeRemaining: <% =tsDateRegistrationValidTimeRemaining.ToString(@"hh\:mm") %> <br />
      tsDateRegistrationValidTimeRemaining: <% =tsDateRegistrationValidTimeRemaining.Hours %> <br />
      
      dtDatePasswordResetToken: <% =dtDatePasswordResetToken %> <br />
      strDatePasswordResetToken: <% =strDatePasswordResetToken%> <br />
      
      PasswordResetToken+24: <% =dtDatePasswordResetToken.AddHours(+24) %> <br />
      tsDatePasswordResetTokenTimeRemaining: <% =tsDatePasswordResetTokenTimeRemaining %> <br />
      tsDatePasswordResetTokenTimeRemaining: <% =tsDatePasswordResetTokenTimeRemaining.ToString(@"hh\:mm") %> <br />
      tsDatePasswordResetTokenTimeRemaining: <% =tsDatePasswordResetTokenTimeRemaining.Hours %> <br />
      
      tsDatePasswordExpiryLessDatePasswordReset: <% =(dtDateUserPasswordExpiry - dtDatePasswordResetToken) %> <br />
      <% =tsDatePasswordExpiryLessDatePasswordReset%> <br />
      <% =passwordReset_Expiry_DifferenceInDays %> <br />
      <% =tsDatePasswordExpiryLessDatePasswordReset.Days %><br />
      strDateUserPasswordChanged: <% =strDateUserPasswordChanged %>

    </div><!-- ./divTestVariables -->



</div>

</form>

</div><!-- ./container -->

<div class="push">
</div><!-- ./push -->

</div><!-- ./wrapper -->

<div class="footercopyrightdivcss">
<br />
<span class="text-muted">
&copy; <asp:Label ID="YearLabel" runat="server" /> Environmental Protection Agency (EPA) Ireland
</span>
</div><!-- ./footercopyright -->

<!-- Google Analytics -->
<script>
  (function (i, s, o, g, r, a, m) {
    i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
      (i[r].q = i[r].q || []).push(arguments)
    }, i[r].l = 1 * new Date(); a = s.createElement(o),
  m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
  })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

  ga('create', 'UA-80866076-1', 'auto');
  var page = document.location.pathname + '?q=' + '<%=strEmail%>';
  ga('set', 'page', page);
  //ga('send', 'pageview');

</script>


</body>
</html>