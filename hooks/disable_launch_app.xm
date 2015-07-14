/********************* Try to disable launch by LastApp and open link in AppStore ******************************/
/************* Accidentally found the way to disable launch apps in general way. It seems well. ****************/

%hook SBAppToAppWorkspaceTransaction

- (id)initWithAlertManager:(id)alertManager from:(id)from to:(id)to withResult:(id)result {
    if (global_Enable && appIdentifierIsInProtectedAppsList([to displayIdentifier])) {
        return nil;
    } else {
        return %orig;
    }
}

%end

/****************************************************************************************************************/
