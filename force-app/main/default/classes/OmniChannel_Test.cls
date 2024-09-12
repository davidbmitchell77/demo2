@isTest(SeeAllData=true)
private class OmniChannel_Test {

    @isTest
    private static void TestMethod01() {
        Account a = new Account(
            Name = 'Case_Trigger_Test.TestMethod01',
            Phone = '(111) 111-1111'
        );
        insert a;

        Contact contact = new Contact(
            AccountId = a.Id,
            FirstName = 'TestMethod01',
            LastName = 'Case_Trigger_Test',
            Email = 'testmethod01.omnichannel@test.com',
            Phone = '(111) 111-1111'
        );
        insert contact;

        List<Case> cases = new List<Case>();
        for (Skill sk : [SELECT Id, MasterLabel FROM Skill LIMIT 20]) {
            Case c = new Case(
                Subject = (a.Name + ' ' + sk.MasterLabel),
                AccountId = a.Id
            );
            cases.add(c);
        }
        insert cases;

        List<String> caseIds = new List<String>();
        for (Case c : cases) {
            caseIds.add(c.Id);
        }

        Test.startTest();
        OmniChannel.routeCases(caseIds);
        Test.stopTest();

        System.assertEquals(cases.size(), [SELECT Id, CaseNumber, Subject, Owner.Name FROM Case WHERE CreatedDate = TODAY].size());        
    }
}