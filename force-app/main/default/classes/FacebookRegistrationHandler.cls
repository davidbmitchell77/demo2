global class FacebookRegistrationHandler implements Auth.RegistrationHandler {

    global Boolean canCreateUser(Auth.UserData data) {
        Boolean result = true;
        if (String.isBlank(data.email)) {
            result = false;
        }
        UserLicense ul = [SELECT TotalLicenses,
                                 UsedLicenses
                            FROM UserLicense
                           WHERE Name = 'Customer Community'
        ];
        if (ul.UsedLicenses >= ul.TotalLicenses) {
            result = false;
        }
        return result;
    }

    global User createUser(Id portalId, Auth.UserData data) {
        User u = new User();
        if (canCreateUser(data) == false) {
            u = null;
        }
        else if (data.attributeMap.containsKey('sfdc_networkid')) {
          //We have a community id, so create a user with community access
            Account a = [SELECT Id FROM Account WHERE Name = 'Facebook SSO'];
            Contact c = new Contact();
            c.AccountId = a.id;
            c.Email = data.email;
            c.FirstName = data.firstName;
            c.LastName = data.lastName;
            insert(c);
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'];
            String username = data.email + '.facebook.sso.com';
            u.Username = ((username.length() > 80) ? username.substring(0,80) : username);
            u.Email = data.email;
            u.LastName = data.lastName;
            u.FirstName = data.firstName;
            String alias = data.firstName + data.lastName;
            u.Alias = ((alias.length() > 8) ? alias.substring(0,8) : alias);
            u.LanguageLocaleKey = UserInfo.getLocale();
            u.LocaleSidKey = UserInfo.getLocale();
            u.EmailEncodingKey = 'UTF-8';
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.ProfileId = p.Id;
            u.ContactId = c.Id;
        }
        else {
          //There is no community id, so create a regular standard user
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            String username = data.email + '.facebook.sso.com';
            u.Username = ((username.length() > 80) ? username.substring(0,80) : username);
            u.Email = data.email;
            u.LastName = data.lastName;
            u.FirstName = data.firstName;
            String alias = data.firstName + data.lastName;
            u.Alias = ((alias.length() > 8) ? alias.substring(0,8) : alias);
            u.LanguageLocaleKey = UserInfo.getLocale();
            u.LocaleSidKey = UserInfo.getLocale();
            u.EmailEncodingKey = 'UTF-8';
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.ProfileId = p.Id;
        }
        return u;
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        User u = new User(Id = userId);
        String username = data.email + '.facebook.sso.com';
        u.Username = ((username.length() > 80) ? username.substring(0,80) : username);
        u.Email = data.email;
        u.LastName = data.lastName;
        u.FirstName = data.firstName;
        String alias = data.firstName + data.lastName;
        u.Alias = ((alias.length() > 8) ? alias.substring(0,8) : alias);
        update(u);
    }
}