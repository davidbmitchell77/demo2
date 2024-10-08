public class OmniChannel {
    private static final String  serviceChannel = 'Case';
    private static final String  routingType = 'SkillsBased';
    private static final String  routingModel = 'MostAvailable';
    private static final String  serviceChannelId = [SELECT Id FROM ServiceChannel WHERE DeveloperName = :serviceChannel].Id;
    private static final Integer capacityWeight = 1;
    private static final Integer routingPriority = 1;
    private static final Integer skillLevel = 5;
    private static final Integer maxSkills = 10;
    private static final Integer queryLimit = 2000;

    @InvocableMethod(category='Case' label='Omni-Channel Routing' description='route cases to agents via Omni-Channel')
    public static void routeCases(List<String> caseIds) {
        List<Case> cases = [SELECT Id,
                                   CaseNumber,
                                   Subject,
                                   Description,
                                   Comments
                              FROM Case
                             WHERE Id IN :caseIds
                          ORDER BY CaseNumber ASC
        ];

        Map<String,PendingServiceRouting> psrMap = new Map<String,PendingServiceRouting>();

        for (Case c : cases) {
            PendingServiceRouting psr = new PendingServiceRouting();
            psr.WorkItemId = c.Id;
            psr.ServiceChannelId = serviceChannelId;
            psr.RoutingType = routingType;
            psr.RoutingModel = routingModel;
            psr.CapacityWeight = capacityWeight;
            psr.RoutingPriority = routingPriority;
            psr.IsReadyForRouting = false;
            psrMap.put(c.Id, psr);
        }

        if (!psrMap.isEmpty()) {
            List<PendingServiceRouting> psrList = psrMap.values();
            insert psrList;
            psrMap.clear();
            for (PendingServiceRouting psr : psrList) {
                psrMap.put(psr.WorkItemId, psr);
            }
        }

        List<Skill> skills = [SELECT Id, MasterLabel FROM Skill LIMIT :queryLimit];

        for (Case c : cases) {
            Set<String> matchingSkillIds = new Set<String>();
            for (Skill s : skills) {
                Boolean skillMatch = false;
                if (nvl(c.Subject, '').containsIgnoreCase(s.MasterLabel    )) { skillMatch = true; } else
                if (nvl(c.Description, '').containsIgnoreCase(s.MasterLabel)) { skillMatch = true; } else
                if (nvl(c.Comments, '').containsIgnoreCase(s.MasterLabel   )) { skillMatch = true; }
                if (skillMatch) {
                    if (!matchingSkillIds.contains(s.Id)) {
                        matchingSkillIds.add(s.Id);
                    }
                }
                if (matchingSkillIds.size() >= maxSkills) { break; }
            }
            List<SkillRequirement> skillReqs = new List<SkillRequirement>();
            for (String msId : matchingSkillIds) {
                SkillRequirement sr = new SkillRequirement();
                sr.SkillId = msId;
                sr.SkillLevel = skillLevel;
                sr.RelatedRecordId = psrMap.get(c.Id).Id;
                skillReqs.add(sr);
            }
            if (!skillReqs.isEmpty()) {
                insert skillReqs;
            }
        }

        for (PendingServiceRouting psr : psrMap.values()) {
            psr.IsReadyForRouting = true;
            psrMap.put(psr.WorkItemId, psr);
        }

        if (!psrMap.isEmpty()) {
            update psrMap.values();
        }
    }

    private static String nvl(String s, String defaultValue) {
        return ((s != null) ? s : defaultValue);
    }
}